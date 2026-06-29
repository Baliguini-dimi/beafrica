// lib/features/auth/data/auth_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream de l'état de connexion
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Inscription
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
    String? country,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // Mettre à jour le displayName dans Firebase Auth
      await user.updateDisplayName(displayName);

      // Créer le document dans Firestore
      final userModel = UserModel(
        uid: user.uid,
        displayName: displayName,
        email: email,
        country: country,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Connexion
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data()!, user.uid);
      } else {
        // Créer le document s'il n'existe pas
        final userModel = UserModel(
          uid: user.uid,
          displayName: user.displayName ?? email.split('@')[0],
          email: email,
          createdAt: DateTime.now(),
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Réinitialisation mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Récupérer le profil utilisateur
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Mettre à jour le profil
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? country,
    String? whatsapp,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (country != null) updates['country'] = country;
    if (whatsapp != null) updates['whatsapp'] = whatsapp;

    await _firestore.collection('users').doc(uid).update(updates);

    if (displayName != null) {
      await _auth.currentUser?.updateDisplayName(displayName);
    }
  }

  // Gestion des erreurs Firebase
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'network-request-failed':
        return 'Erreur réseau. Vérifiez votre connexion.';
      default:
        return 'Une erreur est survenue. Réessayez.';
    }
  }
}
