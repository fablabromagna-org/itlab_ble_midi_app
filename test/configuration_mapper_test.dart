import 'package:flutter_test/flutter_test.dart';
import 'package:itlab_midi_ble/data/configuration_mapper.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/event_type.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';
import 'package:itlab_midi_ble/domain/board/mode.dart';
import 'package:itlab_midi_ble/domain/midi/midi_type.dart';

void main() {
  final ConfigurationMapper _configurationMapper = ConfigurationMapper();

  test('Mapping from Configuration to List<int>', () {
    final mockConfiguration = Configuration(
      'device_test',
      '0.1',
      Mode.SERVER,
      1,
      [
        InternalVariable(0, 123, true),
      ],
      [
        FootswitchConfiguration(
          const FootswitchEvent(
              eventType: EventType.SINGLE,
              midiChannel: 3,
              midiType: MidiType.CC,
              midiNumber: 22,
              midiValueOn: 44,
              groupIndex: 0,
              internalValueIndex: 0),
          const FootswitchEvent(
              eventType: EventType.SINGLE,
              midiChannel: 3,
              midiType: MidiType.CC,
              midiNumber: 22,
              midiValueOn: 44,
              groupIndex: 0,
              internalValueIndex: 0),
        ),
      ],
    );
    final configurationBytes = _configurationMapper.mapFrom(mockConfiguration);

    expect(
        mockConfiguration.toString() ==
            _configurationMapper.mapTo(configurationBytes).toString(),
        true);
  });

  test('Mapping from List<Int> to Configuration', () {
    final mockedBytesConfig = [
      0xf0,
      0x74,
      0x65,
      0x73,
      0x74,
      0x31,
      0x5f,
      0x4e,
      0x55,
      0x58,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00, 0x01, // fw
      0x01, // BLE mode
      0x04, // FS nr

      0x00, 0x06, 0x01, // var 1: min - max - cycle
      0x00, 0x00, 0x00, // var 2: min - max - cycle
      0x00, 0x00, 0x00, // var 2: min - max - cycle
      0x00, 0x00, 0x00, // var 2: min - max - cycle

      0x80, 0x01, 0x01, 0x01, 0x31, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x88,
      0x80, 0x03, 0x01, 0x01, 0x31, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01,
      0x88,

      0x80, 0x03, 0x01, 0x01, 0x31, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01,
      0x88,
      0x80, 0x03, 0x01, 0x01, 0x31, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01,
      0x88,

      0x80, 0x04, 0x01, 0x01, 0x54, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
      0x88,
      0x80, 0x04, 0x01, 0x01, 0x7a, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
      0x88,

      0x80, 0x04, 0x01, 0x01, 0x1c, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
      0x88,
      0x80, 0x04, 0x01, 0x01, 0x7a, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
      0x88,

      0xff
    ];

    final configurationFromBytes =
        _configurationMapper.mapTo(mockedBytesConfig);
    final configBackToBytes =
        _configurationMapper.mapFrom(configurationFromBytes);
    expect(mockedBytesConfig, configBackToBytes);
  });
}
