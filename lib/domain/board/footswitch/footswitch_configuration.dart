import 'package:itlab_midi_ble/domain/board/footswitch/event_type.dart';
import 'package:itlab_midi_ble/domain/midi/midi_type.dart';

/// Footswitch configuarion data class
/// More information here https://github.com/fablabromagna-org/itlab_ble_midi_board/tree/feature/4_fs_controller/software/esp32/platformio_sources/flr_ble_midi_board
class FootswitchConfiguration {
  final EventType eventType;
  final int midiChannel;
  final MidiType midiType;
  final int midiNumber;
  final int midiValueOn;
  final int? midiValueOff;
  final int groupIndex;
  final int internalValueIndex;
  final int? repeatIntervalMs;
  final bool? positiveStep;
  final int? stepValue;

  FootswitchConfiguration(
    this.eventType,
    this.midiChannel,
    this.midiType,
    this.midiNumber,
    this.midiValueOn,
    this.groupIndex,
    this.internalValueIndex, {
    this.repeatIntervalMs,
    this.midiValueOff,
    this.positiveStep,
    this.stepValue,
  });
}
