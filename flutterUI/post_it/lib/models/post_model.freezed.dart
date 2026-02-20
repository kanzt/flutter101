// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get authorAvatar => throw _privateConstructorUsedError;
  PostType get type => throw _privateConstructorUsedError;
  String? get textContent => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String> get viewedByUserIds => throw _privateConstructorUsedError;
  @ColorConverter()
  Color? get gradientStart => throw _privateConstructorUsedError;
  @ColorConverter()
  Color? get gradientEnd => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call({
    String id,
    String authorId,
    String authorName,
    String authorAvatar,
    PostType type,
    String? textContent,
    String? mediaUrl,
    DateTime createdAt,
    List<String> viewedByUserIds,
    @ColorConverter() Color? gradientStart,
    @ColorConverter() Color? gradientEnd,
  });
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatar = null,
    Object? type = null,
    Object? textContent = freezed,
    Object? mediaUrl = freezed,
    Object? createdAt = null,
    Object? viewedByUserIds = null,
    Object? gradientStart = freezed,
    Object? gradientEnd = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorName: null == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String,
            authorAvatar: null == authorAvatar
                ? _value.authorAvatar
                : authorAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PostType,
            textContent: freezed == textContent
                ? _value.textContent
                : textContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaUrl: freezed == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            viewedByUserIds: null == viewedByUserIds
                ? _value.viewedByUserIds
                : viewedByUserIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            gradientStart: freezed == gradientStart
                ? _value.gradientStart
                : gradientStart // ignore: cast_nullable_to_non_nullable
                      as Color?,
            gradientEnd: freezed == gradientEnd
                ? _value.gradientEnd
                : gradientEnd // ignore: cast_nullable_to_non_nullable
                      as Color?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
    _$PostImpl value,
    $Res Function(_$PostImpl) then,
  ) = __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String authorId,
    String authorName,
    String authorAvatar,
    PostType type,
    String? textContent,
    String? mediaUrl,
    DateTime createdAt,
    List<String> viewedByUserIds,
    @ColorConverter() Color? gradientStart,
    @ColorConverter() Color? gradientEnd,
  });
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
    : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatar = null,
    Object? type = null,
    Object? textContent = freezed,
    Object? mediaUrl = freezed,
    Object? createdAt = null,
    Object? viewedByUserIds = null,
    Object? gradientStart = freezed,
    Object? gradientEnd = freezed,
  }) {
    return _then(
      _$PostImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorName: null == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String,
        authorAvatar: null == authorAvatar
            ? _value.authorAvatar
            : authorAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PostType,
        textContent: freezed == textContent
            ? _value.textContent
            : textContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaUrl: freezed == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        viewedByUserIds: null == viewedByUserIds
            ? _value._viewedByUserIds
            : viewedByUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        gradientStart: freezed == gradientStart
            ? _value.gradientStart
            : gradientStart // ignore: cast_nullable_to_non_nullable
                  as Color?,
        gradientEnd: freezed == gradientEnd
            ? _value.gradientEnd
            : gradientEnd // ignore: cast_nullable_to_non_nullable
                  as Color?,
      ),
    );
  }
}

/// @nodoc

class _$PostImpl extends _Post {
  const _$PostImpl({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.type,
    this.textContent,
    this.mediaUrl,
    required this.createdAt,
    final List<String> viewedByUserIds = const [],
    @ColorConverter() this.gradientStart,
    @ColorConverter() this.gradientEnd,
  }) : _viewedByUserIds = viewedByUserIds,
       super._();

  @override
  final String id;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String authorAvatar;
  @override
  final PostType type;
  @override
  final String? textContent;
  @override
  final String? mediaUrl;
  @override
  final DateTime createdAt;
  final List<String> _viewedByUserIds;
  @override
  @JsonKey()
  List<String> get viewedByUserIds {
    if (_viewedByUserIds is EqualUnmodifiableListView) return _viewedByUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewedByUserIds);
  }

  @override
  @ColorConverter()
  final Color? gradientStart;
  @override
  @ColorConverter()
  final Color? gradientEnd;

  @override
  String toString() {
    return 'Post(id: $id, authorId: $authorId, authorName: $authorName, authorAvatar: $authorAvatar, type: $type, textContent: $textContent, mediaUrl: $mediaUrl, createdAt: $createdAt, viewedByUserIds: $viewedByUserIds, gradientStart: $gradientStart, gradientEnd: $gradientEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatar, authorAvatar) ||
                other.authorAvatar == authorAvatar) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.textContent, textContent) ||
                other.textContent == textContent) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._viewedByUserIds,
              _viewedByUserIds,
            ) &&
            (identical(other.gradientStart, gradientStart) ||
                other.gradientStart == gradientStart) &&
            (identical(other.gradientEnd, gradientEnd) ||
                other.gradientEnd == gradientEnd));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    authorId,
    authorName,
    authorAvatar,
    type,
    textContent,
    mediaUrl,
    createdAt,
    const DeepCollectionEquality().hash(_viewedByUserIds),
    gradientStart,
    gradientEnd,
  );

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);
}

abstract class _Post extends Post {
  const factory _Post({
    required final String id,
    required final String authorId,
    required final String authorName,
    required final String authorAvatar,
    required final PostType type,
    final String? textContent,
    final String? mediaUrl,
    required final DateTime createdAt,
    final List<String> viewedByUserIds,
    @ColorConverter() final Color? gradientStart,
    @ColorConverter() final Color? gradientEnd,
  }) = _$PostImpl;
  const _Post._() : super._();

  @override
  String get id;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String get authorAvatar;
  @override
  PostType get type;
  @override
  String? get textContent;
  @override
  String? get mediaUrl;
  @override
  DateTime get createdAt;
  @override
  List<String> get viewedByUserIds;
  @override
  @ColorConverter()
  Color? get gradientStart;
  @override
  @ColorConverter()
  Color? get gradientEnd;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
