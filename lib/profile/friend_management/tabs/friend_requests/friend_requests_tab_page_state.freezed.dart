// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_requests_tab_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FriendRequestsTabPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<FriendItem> get friendRequests => throw _privateConstructorUsedError;

  /// Create a copy of FriendRequestsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendRequestsTabPageStateCopyWith<FriendRequestsTabPageState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestsTabPageStateCopyWith<$Res> {
  factory $FriendRequestsTabPageStateCopyWith(FriendRequestsTabPageState value,
          $Res Function(FriendRequestsTabPageState) then) =
      _$FriendRequestsTabPageStateCopyWithImpl<$Res,
          FriendRequestsTabPageState>;
  @useResult
  $Res call({bool isLoading, List<FriendItem> friendRequests});
}

/// @nodoc
class _$FriendRequestsTabPageStateCopyWithImpl<$Res,
        $Val extends FriendRequestsTabPageState>
    implements $FriendRequestsTabPageStateCopyWith<$Res> {
  _$FriendRequestsTabPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendRequestsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? friendRequests = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      friendRequests: null == friendRequests
          ? _value.friendRequests
          : friendRequests // ignore: cast_nullable_to_non_nullable
              as List<FriendItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendRequestsTabPageStateImplCopyWith<$Res>
    implements $FriendRequestsTabPageStateCopyWith<$Res> {
  factory _$$FriendRequestsTabPageStateImplCopyWith(
          _$FriendRequestsTabPageStateImpl value,
          $Res Function(_$FriendRequestsTabPageStateImpl) then) =
      __$$FriendRequestsTabPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<FriendItem> friendRequests});
}

/// @nodoc
class __$$FriendRequestsTabPageStateImplCopyWithImpl<$Res>
    extends _$FriendRequestsTabPageStateCopyWithImpl<$Res,
        _$FriendRequestsTabPageStateImpl>
    implements _$$FriendRequestsTabPageStateImplCopyWith<$Res> {
  __$$FriendRequestsTabPageStateImplCopyWithImpl(
      _$FriendRequestsTabPageStateImpl _value,
      $Res Function(_$FriendRequestsTabPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendRequestsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? friendRequests = null,
  }) {
    return _then(_$FriendRequestsTabPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      friendRequests: null == friendRequests
          ? _value._friendRequests
          : friendRequests // ignore: cast_nullable_to_non_nullable
              as List<FriendItem>,
    ));
  }
}

/// @nodoc

class _$FriendRequestsTabPageStateImpl implements _FriendRequestsTabPageState {
  const _$FriendRequestsTabPageStateImpl(
      {this.isLoading = true, final List<FriendItem> friendRequests = const []})
      : _friendRequests = friendRequests;

  @override
  @JsonKey()
  final bool isLoading;
  final List<FriendItem> _friendRequests;
  @override
  @JsonKey()
  List<FriendItem> get friendRequests {
    if (_friendRequests is EqualUnmodifiableListView) return _friendRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendRequests);
  }

  @override
  String toString() {
    return 'FriendRequestsTabPageState(isLoading: $isLoading, friendRequests: $friendRequests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestsTabPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._friendRequests, _friendRequests));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_friendRequests));

  /// Create a copy of FriendRequestsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestsTabPageStateImplCopyWith<_$FriendRequestsTabPageStateImpl>
      get copyWith => __$$FriendRequestsTabPageStateImplCopyWithImpl<
          _$FriendRequestsTabPageStateImpl>(this, _$identity);
}

abstract class _FriendRequestsTabPageState
    implements FriendRequestsTabPageState {
  const factory _FriendRequestsTabPageState(
          {final bool isLoading, final List<FriendItem> friendRequests}) =
      _$FriendRequestsTabPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<FriendItem> get friendRequests;

  /// Create a copy of FriendRequestsTabPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendRequestsTabPageStateImplCopyWith<_$FriendRequestsTabPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
