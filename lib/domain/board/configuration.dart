import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_configuration.dart';
import 'package:itlab_midi_ble/domain/board/mode.dart';

/// The configuaration of a single device (ITLAB_MIDI_BLE)
/// More information here https://github.com/fablabromagna-org/itlab_ble_midi_board/tree/feature/4_fs_controller/software/esp32/platformio_sources/flr_ble_midi_board
class Configuration {
  final String deviceName;
  final Mode mode;
  final int numberOfFootswitches;
  final List<InternalVariable> internalVariable;
  final List<FootswitchConfiguration> footswitches;

  Configuration(this.deviceName, this.mode, this.numberOfFootswitches,
      this.internalVariable, this.footswitches);
}

class InternalVariable {
  final int maxValue;
  final int minValue;
  final bool cycle;

  InternalVariable(this.maxValue, this.minValue, this.cycle);
}
