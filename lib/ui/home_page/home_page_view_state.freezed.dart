// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'home_page_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$HomePageViewStateTearOff {
  const _$HomePageViewStateTearOff();

  _HomePageViewState call({Device? connectedDevice}) {
    return _HomePageViewState(
      connectedDevice: connectedDevice,
    );
  }
}

/// @nodoc
const $HomePageViewState = _$HomePageViewStateTearOff();

/// @nodoc
mixin _$HomePageViewState {
  Device? get connectedDevice => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomePageViewStateCopyWith<HomePageViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageViewStateCopyWith<$Res> {
  factory $HomePageViewStateCopyWith(
          HomePageViewState value, $Res Function(HomePageViewState) then) =
      _$HomePageViewStateCopyWithImpl<$Res>;
  $Res call({Device? connectedDevice});
}

/// @nodoc
class _$HomePageViewStateCopyWithImpl<$Res>
    implements $HomePageViewStateCopyWith<$Res> {
  _$HomePageViewStateCopyWithImpl(this._value, this._then);

  final HomePageViewState _value;
  // ignore: unused_field
  final $Res Function(HomePageViewState) _then;

  @override
  $Res call({
    Object? connectedDevice = freezed,
  }) {
    return _then(_value.copyWith(
      connectedDevice: connectedDevice == freezed
          ? _value.connectedDevice
          : connectedDevice // ignore: cast_nullable_to_non_nullable
              as Device?,
    ));
  }
}

/// @nodoc
abstract class _$HomePageViewStateCopyWith<$Res>
    implements $HomePageViewStateCopyWith<$Res> {
  factory _$HomePageViewStateCopyWith(
          _HomePageViewState value, $Res Function(_HomePageViewState) then) =
      __$HomePageViewStateCopyWithImpl<$Res>;
  @override
  $Res call({Device? connectedDevice});
}

/// @nodoc
class __$HomePageViewStateCopyWithImpl<$Res>
    extends _$HomePageViewStateCopyWithImpl<$Res>
    implements _$HomePageViewStateCopyWith<$Res> {
  __$HomePageViewStateCopyWithImpl(
      _HomePageViewState _value, $Res Function(_HomePageViewState) _then)
      : super(_value, (v) => _then(v as _HomePageViewState));

  @override
  _HomePageViewState get _value => super._value as _HomePageViewState;

  @override
  $Res call({
    Object? connectedDevice = freezed,
  }) {
    return _then(_HomePageViewState(
      connectedDevice: connectedDevice == freezed
          ? _value.connectedDevice
          : connectedDevice // ignore: cast_nullable_to_non_nullable
              as Device?,
    ));
  }
}

/// @nodoc

class _$_HomePageViewState implements _HomePageViewState {
  _$_HomePageViewState({this.connectedDevice});

  @override
  final Device? connectedDevice;

  @override
  String toString() {
    return 'HomePageViewState(connectedDevice: $connectedDevice)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomePageViewState &&
            (identical(other.connectedDevice, connectedDevice) ||
                other.connectedDevice == connectedDevice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, connectedDevice);

  @JsonKey(ignore: true)
  @override
  _$HomePageViewStateCopyWith<_HomePageViewState> get copyWith =>
      __$HomePageViewStateCopyWithImpl<_HomePageViewState>(this, _$identity);
}

abstract class _HomePageViewState implements HomePageViewState {
  factory _HomePageViewState({Device? connectedDevice}) = _$_HomePageViewState;

  @override
  Device? get connectedDevice;
  @override
  @JsonKey(ignore: true)
  _$HomePageViewStateCopyWith<_HomePageViewState> get copyWith =>
      throw _privateConstructorUsedError;
}
