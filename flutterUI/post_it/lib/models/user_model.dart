import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String username,
    required String avatarUrl,
    @Default('') String bio,
    @Default([]) List<String> followerIds,
    @Default([]) List<String> followingIds,
    @Default([]) List<String> postIds,
  }) = _AppUser;
}
