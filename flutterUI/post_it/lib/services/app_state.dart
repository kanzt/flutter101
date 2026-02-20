import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import 'mock_data.dart';

// ─── Current User ────────────────────────────────────────────────
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AppUser>(
  (ref) => CurrentUserNotifier(),
);

class CurrentUserNotifier extends StateNotifier<AppUser> {
  CurrentUserNotifier() : super(mockUsers.first);

  void toggleFollow(String targetUserId) {
    final isFollowing = state.followingIds.contains(targetUserId);
    final newFollowing = List<String>.from(state.followingIds);

    if (isFollowing) {
      newFollowing.remove(targetUserId);
    } else {
      newFollowing.add(targetUserId);
    }

    state = state.copyWith(followingIds: newFollowing);

    // Also update the target user's followers
    final targetIdx = mockUsers.indexWhere((u) => u.id == targetUserId);
    if (targetIdx != -1) {
      final targetUser = mockUsers[targetIdx];
      final newFollowers = List<String>.from(targetUser.followerIds);
      if (isFollowing) {
        newFollowers.remove(state.id);
      } else {
        newFollowers.add(state.id);
      }
      mockUsers[targetIdx] = targetUser.copyWith(followerIds: newFollowers);
    }
  }
}

// ─── All Users ───────────────────────────────────────────────────
final allUsersProvider = Provider<List<AppUser>>((ref) {
  return mockUsers;
});

final userByIdProvider = Provider.family<AppUser?, String>((ref, userId) {
  try {
    return mockUsers.firstWhere((u) => u.id == userId);
  } catch (_) {
    return null;
  }
});

// ─── Feed Posts ──────────────────────────────────────────────────
final feedPostsProvider = StateNotifierProvider<FeedPostsNotifier, List<Post>>(
  (ref) => FeedPostsNotifier(ref),
);

class FeedPostsNotifier extends StateNotifier<List<Post>> {
  final Ref _ref;

  FeedPostsNotifier(this._ref) : super([]) {
    _loadFeed();
  }

  void _loadFeed() {
    final currentUser = _ref.read(currentUserProvider);
    // Get posts from followed users that haven't been viewed
    final feed = mockPosts
        .where((p) =>
            currentUser.followingIds.contains(p.authorId) &&
            !p.hasBeenViewedBy(currentUser.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = feed;
  }

  void markAsViewed(String postId) {
    final currentUser = _ref.read(currentUserProvider);
    // Find the post and add user to viewers
    final postIdx = mockPosts.indexWhere((p) => p.id == postId);
    if (postIdx != -1) {
      final post = mockPosts[postIdx];
      final newViewers = List<String>.from(post.viewedByUserIds)
        ..add(currentUser.id);
      mockPosts[postIdx] = post.copyWith(viewedByUserIds: newViewers);
    }
    // Remove from feed
    state = state.where((p) => p.id != postId).toList();
  }

  void removeTopCard() {
    if (state.isNotEmpty) {
      markAsViewed(state.first.id);
    }
  }
}

// ─── All Posts (for profile grids) ───────────────────────────────
final userPostsProvider =
    Provider.family<List<Post>, String>((ref, userId) {
  return mockPosts.where((p) => p.authorId == userId).toList();
});

// ─── Create Post ─────────────────────────────────────────────────
final createPostProvider = Provider((ref) => CreatePostService(ref));

class CreatePostService {
  final Ref _ref;
  CreatePostService(this._ref);

  void createTextPost(String text, int gradientIndex) {
    final user = _ref.read(currentUserProvider);
    final colors = AppColors.postGradients[
        gradientIndex % AppColors.postGradients.length];
    final post = Post(
      id: generateId(),
      authorId: user.id,
      authorName: user.username,
      authorAvatar: user.avatarUrl,
      type: PostType.text,
      textContent: text,
      createdAt: DateTime.now(),
      gradientStart: colors[0],
      gradientEnd: colors[1],
    );
    mockPosts.insert(0, post);
    // Update user's post list
    final userIdx = mockUsers.indexWhere((u) => u.id == user.id);
    if (userIdx != -1) {
      final updatedUser = mockUsers[userIdx];
      mockUsers[userIdx] = updatedUser.copyWith(
        postIds: [...updatedUser.postIds, post.id],
      );
    }
  }

  void createImagePost(String text, String imageUrl) {
    final user = _ref.read(currentUserProvider);
    final post = Post(
      id: generateId(),
      authorId: user.id,
      authorName: user.username,
      authorAvatar: user.avatarUrl,
      type: PostType.image,
      textContent: text,
      mediaUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    mockPosts.insert(0, post);
    final userIdx = mockUsers.indexWhere((u) => u.id == user.id);
    if (userIdx != -1) {
      final updatedUser = mockUsers[userIdx];
      mockUsers[userIdx] = updatedUser.copyWith(
        postIds: [...updatedUser.postIds, post.id],
      );
    }
  }
}
