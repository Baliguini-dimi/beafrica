// lib/features/communaute/providers/communaute_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/forum_post_model.dart';
import '../data/communaute_repository.dart';

final communauteRepositoryProvider = Provider<CommunauteRepository>((ref) {
  return CommunauteRepository();
});

final postsProvider =
    StreamProvider.family<List<ForumPostModel>, ({String theme, String sort})>(
  (ref, params) {
    return ref
        .watch(communauteRepositoryProvider)
        .getPostsByTheme(params.theme, sort: params.sort);
  },
);

final postDetailProvider = StreamProvider.family<ForumPostModel?, String>(
  (ref, postId) {
    return ref.watch(communauteRepositoryProvider).getPost(postId);
  },
);

final repliesProvider = StreamProvider.family<List<ForumReplyModel>, String>(
  (ref, postId) {
    return ref.watch(communauteRepositoryProvider).getReplies(postId);
  },
);

class SortNotifier extends StateNotifier<String> {
  SortNotifier() : super('recent');
  void setSort(String sort) => state = sort;
}

final sortProvider = StateNotifierProvider<SortNotifier, String>((ref) {
  return SortNotifier();
});
