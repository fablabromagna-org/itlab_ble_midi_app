import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';

part 'footswitch_page_view_state.freezed.dart';

@freezed
class FootswitchPageViewState with _$FootswitchPageViewState {
  factory FootswitchPageViewState(
      {@Default(false) bool isDeviceConnected,
      Configuration? configuration}) = _FootswitchPageViewState;
}
