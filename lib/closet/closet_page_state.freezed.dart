// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closet_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClosetPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<String> get photoPaths =>
      throw _privateConstructorUsedError; // 저장된 사진 경로 목록
  List<String> get photoCategories =>
      throw _privateConstructorUsedError; // 각 사진의 카테고리
  List<Map<String, String?>> get photoTags =>
      throw _privateConstructorUsedError;

  /// Create a copy of ClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClosetPageStateCopyWith<ClosetPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClosetPageStateCopyWith<$Res> {
  factory $ClosetPageStateCopyWith(
          ClosetPageState value, $Res Function(ClosetPageState) then) =
      _$ClosetPageStateCopyWithImpl<$Res, ClosetPageState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<String> photoPaths,
      List<String> photoCategories,
      List<Map<String, String?>> photoTags});
}

/// @nodoc
class _$ClosetPageStateCopyWithImpl<$Res, $Val extends ClosetPageState>
    implements $ClosetPageStateCopyWith<$Res> {
  _$ClosetPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? photoPaths = null,
    Object? photoCategories = null,
    Object? photoTags = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClosetPageStateImplCopyWith<$Res>
    implements $ClosetPageStateCopyWith<$Res> {
  factory _$$ClosetPageStateImplCopyWith(_$ClosetPageStateImpl value,
          $Res Function(_$ClosetPageStateImpl) then) =
      __$$ClosetPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<String> photoPaths,
      List<String> photoCategories,
      List<Map<String, String?>> photoTags});
}

/// @nodoc
class __$$ClosetPageStateImplCopyWithImpl<$Res>
    extends _$ClosetPageStateCopyWithImpl<$Res, _$ClosetPageStateImpl>
    implements _$$ClosetPageStateImplCopyWith<$Res> {
  __$$ClosetPageStateImplCopyWithImpl(
      _$ClosetPageStateImpl _value, $Res Function(_$ClosetPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? photoPaths = null,
    Object? photoCategories = null,
    Object? photoTags = null,
  }) {
    return _then(_$ClosetPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc

class _$ClosetPageStateImpl implements _ClosetPageState {
  const _$ClosetPageStateImpl(
      {this.isLoading = true,
      final List<String> photoPaths = const [],
      final List<String> photoCategories = const [],
      final List<Map<String, String?>> photoTags = const []})
      : _photoPaths = photoPaths,
        _photoCategories = photoCategories,
        _photoTags = photoTags;

  @override
  @JsonKey()
  final bool isLoading;
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

  @override
  String toString() {
    return 'ClosetPageState(isLoading: $isLoading, photoPaths: $photoPaths, photoCategories: $photoCategories, photoTags: $photoTags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClosetPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._photoPaths, _photoPaths) &&
            const DeepCollectionEquality()
                .equals(other._photoCategories, _photoCategories) &&
            const DeepCollectionEquality()
                .equals(other._photoTags, _photoTags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_photoPaths),
      const DeepCollectionEquality().hash(_photoCategories),
      const DeepCollectionEquality().hash(_photoTags));

  /// Create a copy of ClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClosetPageStateImplCopyWith<_$ClosetPageStateImpl> get copyWith =>
      __$$ClosetPageStateImplCopyWithImpl<_$ClosetPageStateImpl>(
          this, _$identity);
}

abstract class _ClosetPageState implements ClosetPageState {
  const factory _ClosetPageState(
      {final bool isLoading,
      final List<String> photoPaths,
      final List<String> photoCategories,
      final List<Map<String, String?>> photoTags}) = _$ClosetPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<String> get photoPaths; // 저장된 사진 경로 목록
  @override
  List<String> get photoCategories; // 각 사진의 카테고리
  @override
  List<Map<String, String?>> get photoTags;

  /// Create a copy of ClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClosetPageStateImplCopyWith<_$ClosetPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
