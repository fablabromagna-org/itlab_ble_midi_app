import 'package:itlab_midi_ble/domain/board/footswitch/event_type.dart';
import 'package:itlab_midi_ble/domain/midi/midi_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'footswitch_event.freezed.dart';

/// Footswitch configuarion data class
/// More information here https://github.com/fablabromagna-org/itlab_ble_midi_board/tree/feature/4_fs_controller/software/esp32/platformio_sources/flr_ble_midi_board+

@freezed
class FootswitchEvent with _$FootswitchEvent {
  const factory FootswitchEvent({
    @Default(EventType.SINGLE) final EventType eventType,
    @Default(1) final int midiChannel,
    @Default(MidiType.CC) final MidiType midiType,
    @Default(1) final int midiNumber,
    @Default(1) final int midiValueOn,
    final int? midiValueOff,
    @Default(1) final int groupIndex,
    @Default(1) final int internalValueIndex,
    final int? repeatIntervalMs,
    final bool? positiveStep,
    final int? stepValue,
  }) = _FootswitchEvent;
}
