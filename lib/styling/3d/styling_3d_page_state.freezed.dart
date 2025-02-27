// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'styling_3d_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Styling3DPageState {
  /// 각 카테고리별 GLB 파일 경로
  Map<String, String?> get glbUrls => throw _privateConstructorUsedError;

  /// 각 카테고리별 로딩 상태
  Map<String, bool> get isLoading => throw _privateConstructorUsedError;

  /// 각 카테고리별 변환 진행률 (0~100)
  Map<String, int?> get progress => throw _privateConstructorUsedError;

  /// Create a copy of Styling3DPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Styling3DPageStateCopyWith<Styling3DPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Styling3DPageStateCopyWith<$Res> {
  factory $Styling3DPageStateCopyWith(
          Styling3DPageState value, $Res Function(Styling3DPageState) then) =
      _$Styling3DPageStateCopyWithImpl<$Res, Styling3DPageState>;
  @useResult
  $Res call(
      {Map<String, String?> glbUrls,
      Map<String, bool> isLoading,
      Map<String, int?> progress});
}

/// @nodoc
class _$Styling3DPageStateCopyWithImpl<$Res, $Val extends Styling3DPageState>
    implements $Styling3DPageStateCopyWith<$Res> {
  _$Styling3DPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Styling3DPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? glbUrls = null,
    Object? isLoading = null,
    Object? progress = null,
  }) {
    return _then(_value.copyWith(
      glbUrls: null == glbUrls
          ? _value.glbUrls
          : glbUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, String?>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<String, int?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Styling3DPageStateImplCopyWith<$Res>
    implements $Styling3DPageStateCopyWith<$Res> {
  factory _$$Styling3DPageStateImplCopyWith(_$Styling3DPageStateImpl value,
          $Res Function(_$Styling3DPageStateImpl) then) =
      __$$Styling3DPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String?> glbUrls,
      Map<String, bool> isLoading,
      Map<String, int?> progress});
}

/// @nodoc
class __$$Styling3DPageStateImplCopyWithImpl<$Res>
    extends _$Styling3DPageStateCopyWithImpl<$Res, _$Styling3DPageStateImpl>
    implements _$$Styling3DPageStateImplCopyWith<$Res> {
  __$$Styling3DPageStateImplCopyWithImpl(_$Styling3DPageStateImpl _value,
      $Res Function(_$Styling3DPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of Styling3DPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? glbUrls = null,
    Object? isLoading = null,
    Object? progress = null,
  }) {
    return _then(_$Styling3DPageStateImpl(
      glbUrls: null == glbUrls
          ? _value._glbUrls
          : glbUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, String?>,
      isLoading: null == isLoading
          ? _value._isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      progress: null == progress
          ? _value._progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<String, int?>,
    ));
  }
}

/// @nodoc

class _$Styling3DPageStateImpl implements _Styling3DPageState {
  const _$Styling3DPageStateImpl(
      {final Map<String, String?> glbUrls = const {
        '상의': null,
        '하의': null,
        '아우터': null,
        '신발': null
      },
      final Map<String, bool> isLoading = const {
        '상의': false,
        '하의': false,
        '아우터': false,
        '신발': false
      },
      final Map<String, int?> progress = const {
        '상의': null,
        '하의': null,
        '아우터': null,
        '신발': null
      }})
      : _glbUrls = glbUrls,
        _isLoading = isLoading,
        _progress = progress;

  /// 각 카테고리별 GLB 파일 경로
  final Map<String, String?> _glbUrls;

  /// 각 카테고리별 GLB 파일 경로
  @override
  @JsonKey()
  Map<String, String?> get glbUrls {
    if (_glbUrls is EqualUnmodifiableMapView) return _glbUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_glbUrls);
  }

  /// 각 카테고리별 로딩 상태
  final Map<String, bool> _isLoading;

  /// 각 카테고리별 로딩 상태
  @override
  @JsonKey()
  Map<String, bool> get isLoading {
    if (_isLoading is EqualUnmodifiableMapView) return _isLoading;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_isLoading);
  }

  /// 각 카테고리별 변환 진행률 (0~100)
  final Map<String, int?> _progress;

  /// 각 카테고리별 변환 진행률 (0~100)
  @override
  @JsonKey()
  Map<String, int?> get progress {
    if (_progress is EqualUnmodifiableMapView) return _progress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_progress);
  }

  @override
  String toString() {
    return 'Styling3DPageState(glbUrls: $glbUrls, isLoading: $isLoading, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Styling3DPageStateImpl &&
            const DeepCollectionEquality().equals(other._glbUrls, _glbUrls) &&
            const DeepCollectionEquality()
                .equals(other._isLoading, _isLoading) &&
            const DeepCollectionEquality().equals(other._progress, _progress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_glbUrls),
      const DeepCollectionEquality().hash(_isLoading),
      const DeepCollectionEquality().hash(_progress));

  /// Create a copy of Styling3DPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Styling3DPageStateImplCopyWith<_$Styling3DPageStateImpl> get copyWith =>
      __$$Styling3DPageStateImplCopyWithImpl<_$Styling3DPageStateImpl>(
          this, _$identity);
}

abstract class _Styling3DPageState implements Styling3DPageState {
  const factory _Styling3DPageState(
      {final Map<String, String?> glbUrls,
      final Map<String, bool> isLoading,
      final Map<String, int?> progress}) = _$Styling3DPageStateImpl;

  /// 각 카테고리별 GLB 파일 경로
  @override
  Map<String, String?> get glbUrls;

  /// 각 카테고리별 로딩 상태
  @override
  Map<String, bool> get isLoading;

  /// 각 카테고리별 변환 진행률 (0~100)
  @override
  Map<String, int?> get progress;

  /// Create a copy of Styling3DPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Styling3DPageStateImplCopyWith<_$Styling3DPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
