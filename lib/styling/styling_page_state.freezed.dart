// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'styling_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StylingPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  int get selectedTab => throw _privateConstructorUsedError; // 선택된 탭
  String? get selectedCategory =>
      throw _privateConstructorUsedError; // 선택된 카테고리 이름
  List<String> get categoryPhotos =>
      throw _privateConstructorUsedError; // 선택된 카테고리의 모든 사진 목록
  Map<String, String> get selectedPhotos => throw _privateConstructorUsedError;

  /// Create a copy of StylingPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StylingPageStateCopyWith<StylingPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StylingPageStateCopyWith<$Res> {
  factory $StylingPageStateCopyWith(
          StylingPageState value, $Res Function(StylingPageState) then) =
      _$StylingPageStateCopyWithImpl<$Res, StylingPageState>;
  @useResult
  $Res call(
      {bool isLoading,
      int selectedTab,
      String? selectedCategory,
      List<String> categoryPhotos,
      Map<String, String> selectedPhotos});
}

/// @nodoc
class _$StylingPageStateCopyWithImpl<$Res, $Val extends StylingPageState>
    implements $StylingPageStateCopyWith<$Res> {
  _$StylingPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StylingPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? selectedTab = null,
    Object? selectedCategory = freezed,
    Object? categoryPhotos = null,
    Object? selectedPhotos = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as int,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryPhotos: null == categoryPhotos
          ? _value.categoryPhotos
          : categoryPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedPhotos: null == selectedPhotos
          ? _value.selectedPhotos
          : selectedPhotos // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StylingPageStateImplCopyWith<$Res>
    implements $StylingPageStateCopyWith<$Res> {
  factory _$$StylingPageStateImplCopyWith(_$StylingPageStateImpl value,
          $Res Function(_$StylingPageStateImpl) then) =
      __$$StylingPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      int selectedTab,
      String? selectedCategory,
      List<String> categoryPhotos,
      Map<String, String> selectedPhotos});
}

/// @nodoc
class __$$StylingPageStateImplCopyWithImpl<$Res>
    extends _$StylingPageStateCopyWithImpl<$Res, _$StylingPageStateImpl>
    implements _$$StylingPageStateImplCopyWith<$Res> {
  __$$StylingPageStateImplCopyWithImpl(_$StylingPageStateImpl _value,
      $Res Function(_$StylingPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StylingPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? selectedTab = null,
    Object? selectedCategory = freezed,
    Object? categoryPhotos = null,
    Object? selectedPhotos = null,
  }) {
    return _then(_$StylingPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as int,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryPhotos: null == categoryPhotos
          ? _value._categoryPhotos
          : categoryPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedPhotos: null == selectedPhotos
          ? _value._selectedPhotos
          : selectedPhotos // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$StylingPageStateImpl implements _StylingPageState {
  const _$StylingPageStateImpl(
      {this.isLoading = true,
      this.selectedTab = 0,
      this.selectedCategory = null,
      final List<String> categoryPhotos = const [],
      final Map<String, String> selectedPhotos = const {}})
      : _categoryPhotos = categoryPhotos,
        _selectedPhotos = selectedPhotos;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int selectedTab;
// 선택된 탭
  @override
  @JsonKey()
  final String? selectedCategory;
// 선택된 카테고리 이름
  final List<String> _categoryPhotos;
// 선택된 카테고리 이름
  @override
  @JsonKey()
  List<String> get categoryPhotos {
    if (_categoryPhotos is EqualUnmodifiableListView) return _categoryPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryPhotos);
  }

// 선택된 카테고리의 모든 사진 목록
  final Map<String, String> _selectedPhotos;
// 선택된 카테고리의 모든 사진 목록
  @override
  @JsonKey()
  Map<String, String> get selectedPhotos {
    if (_selectedPhotos is EqualUnmodifiableMapView) return _selectedPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedPhotos);
  }

  @override
  String toString() {
    return 'StylingPageState(isLoading: $isLoading, selectedTab: $selectedTab, selectedCategory: $selectedCategory, categoryPhotos: $categoryPhotos, selectedPhotos: $selectedPhotos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StylingPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.selectedTab, selectedTab) ||
                other.selectedTab == selectedTab) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            const DeepCollectionEquality()
                .equals(other._categoryPhotos, _categoryPhotos) &&
            const DeepCollectionEquality()
                .equals(other._selectedPhotos, _selectedPhotos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      selectedTab,
      selectedCategory,
      const DeepCollectionEquality().hash(_categoryPhotos),
      const DeepCollectionEquality().hash(_selectedPhotos));

  /// Create a copy of StylingPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StylingPageStateImplCopyWith<_$StylingPageStateImpl> get copyWith =>
      __$$StylingPageStateImplCopyWithImpl<_$StylingPageStateImpl>(
          this, _$identity);
}

abstract class _StylingPageState implements StylingPageState {
  const factory _StylingPageState(
      {final bool isLoading,
      final int selectedTab,
      final String? selectedCategory,
      final List<String> categoryPhotos,
      final Map<String, String> selectedPhotos}) = _$StylingPageStateImpl;

  @override
  bool get isLoading;
  @override
  int get selectedTab; // 선택된 탭
  @override
  String? get selectedCategory; // 선택된 카테고리 이름
  @override
  List<String> get categoryPhotos; // 선택된 카테고리의 모든 사진 목록
  @override
  Map<String, String> get selectedPhotos;

  /// Create a copy of StylingPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StylingPageStateImplCopyWith<_$StylingPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
