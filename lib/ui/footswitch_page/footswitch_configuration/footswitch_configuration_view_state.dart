import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';

part 'footswitch_configuration_view_state.freezed.dart';

@freezed
class FootswitchConfigurationViewState with _$FootswitchConfigurationViewState {
  factory FootswitchConfigurationViewState(
      {@Default(FootswitchEvent()) final FootswitchEvent tapConfiguration,
      @Default(FootswitchEvent()) final FootswitchEvent holdConfiguration,
      @Default(0) final int groupIndex}) = _FootswitchConfigurationViewState;
}
