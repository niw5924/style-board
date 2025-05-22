// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_closet_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FriendClosetPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<ClosetItem> get friendClosetItems => throw _privateConstructorUsedError;

  /// Create a copy of FriendClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendClosetPageStateCopyWith<FriendClosetPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendClosetPageStateCopyWith<$Res> {
  factory $FriendClosetPageStateCopyWith(FriendClosetPageState value,
          $Res Function(FriendClosetPageState) then) =
      _$FriendClosetPageStateCopyWithImpl<$Res, FriendClosetPageState>;
  @useResult
  $Res call({bool isLoading, List<ClosetItem> friendClosetItems});
}

/// @nodoc
class _$FriendClosetPageStateCopyWithImpl<$Res,
        $Val extends FriendClosetPageState>
    implements $FriendClosetPageStateCopyWith<$Res> {
  _$FriendClosetPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? friendClosetItems = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      friendClosetItems: null == friendClosetItems
          ? _value.friendClosetItems
          : friendClosetItems // ignore: cast_nullable_to_non_nullable
              as List<ClosetItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendClosetPageStateImplCopyWith<$Res>
    implements $FriendClosetPageStateCopyWith<$Res> {
  factory _$$FriendClosetPageStateImplCopyWith(
          _$FriendClosetPageStateImpl value,
          $Res Function(_$FriendClosetPageStateImpl) then) =
      __$$FriendClosetPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<ClosetItem> friendClosetItems});
}

/// @nodoc
class __$$FriendClosetPageStateImplCopyWithImpl<$Res>
    extends _$FriendClosetPageStateCopyWithImpl<$Res,
        _$FriendClosetPageStateImpl>
    implements _$$FriendClosetPageStateImplCopyWith<$Res> {
  __$$FriendClosetPageStateImplCopyWithImpl(_$FriendClosetPageStateImpl _value,
      $Res Function(_$FriendClosetPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? friendClosetItems = null,
  }) {
    return _then(_$FriendClosetPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      friendClosetItems: null == friendClosetItems
          ? _value._friendClosetItems
          : friendClosetItems // ignore: cast_nullable_to_non_nullable
              as List<ClosetItem>,
    ));
  }
}

/// @nodoc

class _$FriendClosetPageStateImpl implements _FriendClosetPageState {
  const _$FriendClosetPageStateImpl(
      {this.isLoading = true,
      final List<ClosetItem> friendClosetItems = const []})
      : _friendClosetItems = friendClosetItems;

  @override
  @JsonKey()
  final bool isLoading;
  final List<ClosetItem> _friendClosetItems;
  @override
  @JsonKey()
  List<ClosetItem> get friendClosetItems {
    if (_friendClosetItems is EqualUnmodifiableListView)
      return _friendClosetItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendClosetItems);
  }

  @override
  String toString() {
    return 'FriendClosetPageState(isLoading: $isLoading, friendClosetItems: $friendClosetItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendClosetPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._friendClosetItems, _friendClosetItems));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_friendClosetItems));

  /// Create a copy of FriendClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendClosetPageStateImplCopyWith<_$FriendClosetPageStateImpl>
      get copyWith => __$$FriendClosetPageStateImplCopyWithImpl<
          _$FriendClosetPageStateImpl>(this, _$identity);
}

abstract class _FriendClosetPageState implements FriendClosetPageState {
  const factory _FriendClosetPageState(
      {final bool isLoading,
      final List<ClosetItem> friendClosetItems}) = _$FriendClosetPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<ClosetItem> get friendClosetItems;

  /// Create a copy of FriendClosetPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendClosetPageStateImplCopyWith<_$FriendClosetPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
