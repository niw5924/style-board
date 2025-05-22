// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_friends_tab_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyFriendsTabPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<FriendItem> get friendItems => throw _privateConstructorUsedError;

  /// Create a copy of MyFriendsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyFriendsTabPageStateCopyWith<MyFriendsTabPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyFriendsTabPageStateCopyWith<$Res> {
  factory $MyFriendsTabPageStateCopyWith(MyFriendsTabPageState value,
          $Res Function(MyFriendsTabPageState) then) =
      _$MyFriendsTabPageStateCopyWithImpl<$Res, MyFriendsTabPageState>;
  @useResult
  $Res call({bool isLoading, List<FriendItem> friendItems});
}

/// @nodoc
class _$MyFriendsTabPageStateCopyWithImpl<$Res,
        $Val extends MyFriendsTabPageState>
    implements $MyFriendsTabPageStateCopyWith<$Res> {
  _$MyFriendsTabPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyFriendsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? friendItems = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      friendItems: null == friendItems
          ? _value.friendItems
          : friendItems // ignore: cast_nullable_to_non_nullable
              as List<FriendItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyFriendsTabPageStateImplCopyWith<$Res>
    implements $MyFriendsTabPageStateCopyWith<$Res> {
  factory _$$MyFriendsTabPageStateImplCopyWith(
          _$MyFriendsTabPageStateImpl value,
          $Res Function(_$MyFriendsTabPageStateImpl) then) =
      __$$MyFriendsTabPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<FriendItem> friendItems});
}

/// @nodoc
class __$$MyFriendsTabPageStateImplCopyWithImpl<$Res>
    extends _$MyFriendsTabPageStateCopyWithImpl<$Res,
        _$MyFriendsTabPageStateImpl>
    implements _$$MyFriendsTabPageStateImplCopyWith<$Res> {
  __$$MyFriendsTabPageStateImplCopyWithImpl(_$MyFriendsTabPageStateImpl _value,
      $Res Function(_$MyFriendsTabPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyFriendsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? friendItems = null,
  }) {
    return _then(_$MyFriendsTabPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      friendItems: null == friendItems
          ? _value._friendItems
          : friendItems // ignore: cast_nullable_to_non_nullable
              as List<FriendItem>,
    ));
  }
}

/// @nodoc

class _$MyFriendsTabPageStateImpl implements _MyFriendsTabPageState {
  const _$MyFriendsTabPageStateImpl(
      {this.isLoading = true, final List<FriendItem> friendItems = const []})
      : _friendItems = friendItems;

  @override
  @JsonKey()
  final bool isLoading;
  final List<FriendItem> _friendItems;
  @override
  @JsonKey()
  List<FriendItem> get friendItems {
    if (_friendItems is EqualUnmodifiableListView) return _friendItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendItems);
  }

  @override
  String toString() {
    return 'MyFriendsTabPageState(isLoading: $isLoading, friendItems: $friendItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyFriendsTabPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._friendItems, _friendItems));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_friendItems));

  /// Create a copy of MyFriendsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyFriendsTabPageStateImplCopyWith<_$MyFriendsTabPageStateImpl>
      get copyWith => __$$MyFriendsTabPageStateImplCopyWithImpl<
          _$MyFriendsTabPageStateImpl>(this, _$identity);
}

abstract class _MyFriendsTabPageState implements MyFriendsTabPageState {
  const factory _MyFriendsTabPageState(
      {final bool isLoading,
      final List<FriendItem> friendItems}) = _$MyFriendsTabPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<FriendItem> get friendItems;

  /// Create a copy of MyFriendsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyFriendsTabPageStateImplCopyWith<_$MyFriendsTabPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
