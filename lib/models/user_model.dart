// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? country;
  final String role;
  final bool isVerifiedSeller;
  final String? whatsapp;
  final DateTime createdAt;
  final bool isBanned;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.country,
    this.role = 'user',
    this.isVerifiedSeller = false,
    this.whatsapp,
    required this.createdAt,
    this.isBanned = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      country: json['country'],
      role: json['role'] ?? 'user',
      isVerifiedSeller: json['isVerifiedSeller'] ?? false,
      whatsapp: json['whatsapp'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isBanned: json['isBanned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'country': country,
        'role': role,
        'isVerifiedSeller': isVerifiedSeller,
        'whatsapp': whatsapp,
        'createdAt': createdAt,
        'isBanned': isBanned,
      };

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? country,
    String? whatsapp,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      country: country ?? this.country,
      role: role,
      isVerifiedSeller: isVerifiedSeller,
      whatsapp: whatsapp ?? this.whatsapp,
      createdAt: createdAt,
      isBanned: isBanned,
    );
  }
}
