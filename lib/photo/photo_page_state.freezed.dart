// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PhotoPageState {
  List<String> get photoPaths =>
      throw _privateConstructorUsedError; // 저장된 사진 경로 목록
  List<String> get photoCategories =>
      throw _privateConstructorUsedError; // 각 사진의 카테고리
  List<Map<String, String?>> get photoTags =>
      throw _privateConstructorUsedError; // 각 사진의 태그 정보
  bool get isLoading => throw _privateConstructorUsedError; // 로딩 상태
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PhotoPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoPageStateCopyWith<PhotoPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoPageStateCopyWith<$Res> {
  factory $PhotoPageStateCopyWith(
          PhotoPageState value, $Res Function(PhotoPageState) then) =
      _$PhotoPageStateCopyWithImpl<$Res, PhotoPageState>;
  @useResult
  $Res call(
      {List<String> photoPaths,
      List<String> photoCategories,
      List<Map<String, String?>> photoTags,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$PhotoPageStateCopyWithImpl<$Res, $Val extends PhotoPageState>
    implements $PhotoPageStateCopyWith<$Res> {
  _$PhotoPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoPaths = null,
    Object? photoCategories = null,
    Object? photoTags = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      photoPaths: null == photoPaths
          ? _value.photoPaths
          : photoPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoCategories: null == photoCategories
          ? _value.photoCategories
          : photoCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoTags: null == photoTags
          ? _value.photoTags
          : photoTags // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String?>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhotoPageStateImplCopyWith<$Res>
    implements $PhotoPageStateCopyWith<$Res> {
  factory _$$PhotoPageStateImplCopyWith(_$PhotoPageStateImpl value,
          $Res Function(_$PhotoPageStateImpl) then) =
      __$$PhotoPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> photoPaths,
      List<String> photoCategories,
      List<Map<String, String?>> photoTags,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$PhotoPageStateImplCopyWithImpl<$Res>
    extends _$PhotoPageStateCopyWithImpl<$Res, _$PhotoPageStateImpl>
    implements _$$PhotoPageStateImplCopyWith<$Res> {
  __$$PhotoPageStateImplCopyWithImpl(
      _$PhotoPageStateImpl _value, $Res Function(_$PhotoPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoPaths = null,
    Object? photoCategories = null,
    Object? photoTags = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$PhotoPageStateImpl(
      photoPaths: null == photoPaths
          ? _value._photoPaths
          : photoPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoCategories: null == photoCategories
          ? _value._photoCategories
          : photoCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoTags: null == photoTags
          ? _value._photoTags
          : photoTags // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String?>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PhotoPageStateImpl implements _PhotoPageState {
  const _$PhotoPageStateImpl(
      {final List<String> photoPaths = const [],
      final List<String> photoCategories = const [],
      final List<Map<String, String?>> photoTags = const [],
      this.isLoading = false,
      this.errorMessage})
      : _photoPaths = photoPaths,
        _photoCategories = photoCategories,
        _photoTags = photoTags;

  final List<String> _photoPaths;
  @override
  @JsonKey()
  List<String> get photoPaths {
    if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoPaths);
  }

// 저장된 사진 경로 목록
  final List<String> _photoCategories;
// 저장된 사진 경로 목록
  @override
  @JsonKey()
  List<String> get photoCategories {
    if (_photoCategories is EqualUnmodifiableListView) return _photoCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoCategories);
  }

// 각 사진의 카테고리
  final List<Map<String, String?>> _photoTags;
// 각 사진의 카테고리
  @override
  @JsonKey()
  List<Map<String, String?>> get photoTags {
    if (_photoTags is EqualUnmodifiableListView) return _photoTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoTags);
  }

// 각 사진의 태그 정보
  @override
  @JsonKey()
  final bool isLoading;
// 로딩 상태
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PhotoPageState(photoPaths: $photoPaths, photoCategories: $photoCategories, photoTags: $photoTags, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoPageStateImpl &&
            const DeepCollectionEquality()
                .equals(other._photoPaths, _photoPaths) &&
            const DeepCollectionEquality()
                .equals(other._photoCategories, _photoCategories) &&
            const DeepCollectionEquality()
                .equals(other._photoTags, _photoTags) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_photoPaths),
      const DeepCollectionEquality().hash(_photoCategories),
      const DeepCollectionEquality().hash(_photoTags),
      isLoading,
      errorMessage);

  /// Create a copy of PhotoPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoPageStateImplCopyWith<_$PhotoPageStateImpl> get copyWith =>
      __$$PhotoPageStateImplCopyWithImpl<_$PhotoPageStateImpl>(
          this, _$identity);
}

abstract class _PhotoPageState implements PhotoPageState {
  const factory _PhotoPageState(
      {final List<String> photoPaths,
      final List<String> photoCategories,
      final List<Map<String, String?>> photoTags,
      final bool isLoading,
      final String? errorMessage}) = _$PhotoPageStateImpl;

  @override
  List<String> get photoPaths; // 저장된 사진 경로 목록
  @override
  List<String> get photoCategories; // 각 사진의 카테고리
  @override
  List<Map<String, String?>> get photoTags; // 각 사진의 태그 정보
  @override
  bool get isLoading; // 로딩 상태
  @override
  String? get errorMessage;

  /// Create a copy of PhotoPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoPageStateImplCopyWith<_$PhotoPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
