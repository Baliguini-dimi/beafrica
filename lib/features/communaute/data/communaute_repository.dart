// lib/features/communaute/data/communaute_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/forum_post_model.dart';

class CommunauteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thèmes du forum
  static const List<Map<String, String>> themes = [
    {'id': 'diaspora', 'label': 'Vie en diaspora', 'icon': 'public'},
    {'id': 'retour', 'label': 'Retour au pays', 'icon': 'flight_land'},
    {'id': 'emploi', 'label': 'Emploi & Business', 'icon': 'work'},
    {'id': 'culture', 'label': 'Culture & Langue', 'icon': 'language'},
    {
      'id': 'entraide',
      'label': 'Aide & Entraide',
      'icon': 'volunteer_activism'
    },
    {'id': 'actualites', 'label': 'Actualités & Débats', 'icon': 'forum'},
  ];

  Stream<List<ForumPostModel>> getPostsByTheme(String theme,
      {String sort = 'recent'}) {
    Query query =
        _firestore.collection('forum_posts').where('theme', isEqualTo: theme);

    switch (sort) {
      case 'popular':
        query = query.orderBy('likes', descending: true);
        break;
      case 'unanswered':
        query = query
            .where('replyCount', isEqualTo: 0)
            .orderBy('createdAt', descending: true);
        break;
      default:
        query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ForumPostModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Stream<ForumPostModel?> getPost(String postId) {
    return _firestore
        .collection('forum_posts')
        .doc(postId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return ForumPostModel.fromJson(doc.data()!, doc.id);
    });
  }

  Stream<List<ForumReplyModel>> getReplies(String postId) {
    return _firestore
        .collection('forum_posts')
        .doc(postId)
        .collection('replies')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ForumReplyModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Future<String> createPost(ForumPostModel post) async {
    final doc = await _firestore.collection('forum_posts').add(post.toJson());
    return doc.id;
  }

  Future<void> addReply(String postId, ForumReplyModel reply) async {
    final batch = _firestore.batch();

    final replyRef = _firestore
        .collection('forum_posts')
        .doc(postId)
        .collection('replies')
        .doc();
    batch.set(replyRef, reply.toJson());

    final postRef = _firestore.collection('forum_posts').doc(postId);
    batch.update(postRef, {'replyCount': FieldValue.increment(1)});

    await batch.commit();
  }

  Future<void> react(String postId, String reactionType) async {
    await _firestore.collection('forum_posts').doc(postId).update({
      reactionType: FieldValue.increment(1),
    });
  }

  Future<void> reportPost(String postId) async {
    await _firestore.collection('forum_posts').doc(postId).update({
      'reportCount': FieldValue.increment(1),
    });
  }
}
