import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';

class FootswitchConfiguration {
  final FootswitchEvent tapConfiguration;
  final FootswitchEvent holdConfiguration;

  FootswitchConfiguration(this.tapConfiguration, this.holdConfiguration);
}
