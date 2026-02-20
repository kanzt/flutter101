import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';

enum PostType { text, image, video }

@freezed
class Post with _$Post {
  const Post._();

  const factory Post({
    required String id,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required PostType type,
    String? textContent,
    String? mediaUrl,
    required DateTime createdAt,
    @Default([]) List<String> viewedByUserIds,
    @ColorConverter() Color? gradientStart,
    @ColorConverter() Color? gradientEnd,
  }) = _Post;

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  bool hasBeenViewedBy(String userId) => viewedByUserIds.contains(userId);
}

/// Converter so freezed can handle `dart:ui` [Color] values.
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.toARGB32();
}
