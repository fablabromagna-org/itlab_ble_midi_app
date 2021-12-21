import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itlab_midi_ble/ble/device.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';

part 'home_page_view_state.freezed.dart';

@freezed
class HomePageViewState with _$HomePageViewState {
  factory HomePageViewState(
      {Device? connectedDevice,
      Configuration? configuration}) = _HomePageViewState;
}
