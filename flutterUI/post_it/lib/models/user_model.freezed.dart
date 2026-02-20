// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppUser {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  List<String> get followerIds => throw _privateConstructorUsedError;
  List<String> get followingIds => throw _privateConstructorUsedError;
  List<String> get postIds => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call({
    String id,
    String username,
    String avatarUrl,
    String bio,
    List<String> followerIds,
    List<String> followingIds,
    List<String> postIds,
  });
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = null,
    Object? bio = null,
    Object? followerIds = null,
    Object? followingIds = null,
    Object? postIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: null == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: null == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String,
            followerIds: null == followerIds
                ? _value.followerIds
                : followerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            followingIds: null == followingIds
                ? _value.followingIds
                : followingIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            postIds: null == postIds
                ? _value.postIds
                : postIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
    _$AppUserImpl value,
    $Res Function(_$AppUserImpl) then,
  ) = __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String username,
    String avatarUrl,
    String bio,
    List<String> followerIds,
    List<String> followingIds,
    List<String> postIds,
  });
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
    _$AppUserImpl _value,
    $Res Function(_$AppUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = null,
    Object? bio = null,
    Object? followerIds = null,
    Object? followingIds = null,
    Object? postIds = null,
  }) {
    return _then(
      _$AppUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: null == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: null == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String,
        followerIds: null == followerIds
            ? _value._followerIds
            : followerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        followingIds: null == followingIds
            ? _value._followingIds
            : followingIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        postIds: null == postIds
            ? _value._postIds
            : postIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.bio = '',
    final List<String> followerIds = const [],
    final List<String> followingIds = const [],
    final List<String> postIds = const [],
  }) : _followerIds = followerIds,
       _followingIds = followingIds,
       _postIds = postIds;

  @override
  final String id;
  @override
  final String username;
  @override
  final String avatarUrl;
  @override
  @JsonKey()
  final String bio;
  final List<String> _followerIds;
  @override
  @JsonKey()
  List<String> get followerIds {
    if (_followerIds is EqualUnmodifiableListView) return _followerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followerIds);
  }

  final List<String> _followingIds;
  @override
  @JsonKey()
  List<String> get followingIds {
    if (_followingIds is EqualUnmodifiableListView) return _followingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followingIds);
  }

  final List<String> _postIds;
  @override
  @JsonKey()
  List<String> get postIds {
    if (_postIds is EqualUnmodifiableListView) return _postIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_postIds);
  }

  @override
  String toString() {
    return 'AppUser(id: $id, username: $username, avatarUrl: $avatarUrl, bio: $bio, followerIds: $followerIds, followingIds: $followingIds, postIds: $postIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(
              other._followerIds,
              _followerIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._followingIds,
              _followingIds,
            ) &&
            const DeepCollectionEquality().equals(other._postIds, _postIds));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    avatarUrl,
    bio,
    const DeepCollectionEquality().hash(_followerIds),
    const DeepCollectionEquality().hash(_followingIds),
    const DeepCollectionEquality().hash(_postIds),
  );

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);
}

abstract class _AppUser implements AppUser {
  const factory _AppUser({
    required final String id,
    required final String username,
    required final String avatarUrl,
    final String bio,
    final List<String> followerIds,
    final List<String> followingIds,
    final List<String> postIds,
  }) = _$AppUserImpl;

  @override
  String get id;
  @override
  String get username;
  @override
  String get avatarUrl;
  @override
  String get bio;
  @override
  List<String> get followerIds;
  @override
  List<String> get followingIds;
  @override
  List<String> get postIds;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
