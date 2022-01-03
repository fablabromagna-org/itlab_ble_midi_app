import 'package:itlab_midi_ble/data/mapper.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/event_type.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';
import 'package:itlab_midi_ble/domain/board/mode.dart';
import 'package:itlab_midi_ble/domain/midi/midi_type.dart';

class ConfigurationMapper extends Mapper<List<int>, Configuration> {
  final InternvalVariableMapper _internvalVariableMapper =
      InternvalVariableMapper();
  final FootswitchConfigurationMapper _footswitchMapper =
      FootswitchConfigurationMapper();

  @override
  Configuration mapTo(List<int> objectToMap) {
    return Configuration(
      String.fromCharCodes(() {
        final charList = objectToMap.sublist(1, 33);
        // this remove padding
        //List.from is necessary because charList is fixed length
        List.from(charList).removeWhere((element) => element == 0x00);
        return charList;
      }.call()),
      '${objectToMap[33]}.${objectToMap[34]}',
      ModeExtension.getModeFromValue(objectToMap[35]),
      objectToMap[36],
      Iterable.generate(
          objectToMap
                  .sublist(
                      37, objectToMap.indexWhere((element) => element == 0x80))
                  .length ~/
              InternvalVariableMapper.byteSize,
          (i) => _internvalVariableMapper.mapTo(objectToMap
              .sublist(37, objectToMap.indexWhere((element) => element == 0x80))
              .sublist(
                  i * InternvalVariableMapper.byteSize,
                  i * InternvalVariableMapper.byteSize +
                      InternvalVariableMapper.byteSize))).toList(),
      Iterable.generate(
          objectToMap
                  .sublist(objectToMap.indexWhere((element) => element == 0x80))
                  .length ~/
              FootswitchConfigurationMapper.byteSize,
          (i) => _footswitchMapper.mapTo(objectToMap
              .sublist(objectToMap.indexWhere((element) => element == 0x80))
              .sublist(
                i * FootswitchConfigurationMapper.byteSize,
                i * FootswitchConfigurationMapper.byteSize +
                    FootswitchConfigurationMapper.byteSize,
              ))).toList(),
    );
  }

  @override
  List<int> mapFrom(Configuration objectToMap) {
    return [
      0xf0,
      ...objectToMap.deviceName.padRight(32, String.fromCharCode(0)).codeUnits,
      int.parse(objectToMap.version.split('.')[0]),
      int.parse(objectToMap.version.split('.')[1]),
      objectToMap.mode.value,
      objectToMap.numberOfFootswitches,
      ...objectToMap.internalVariable
          .map((i) => (_internvalVariableMapper.mapFrom(i)))
          .expand((element) => element),
      ...objectToMap.footswitches
          .map((i) => (_footswitchMapper.mapFrom(i)))
          .expand((element) => element),
      0xff
    ];
  }
}

class InternvalVariableMapper extends Mapper<List<int>, InternalVariable> {
  static const int byteSize = 3;

  @override
  InternalVariable mapTo(List<int> objectToMap) {
    return InternalVariable(
        objectToMap[0], objectToMap[1], objectToMap[2] == 1);
  }

  @override
  List<int> mapFrom(InternalVariable objectToMap) {
    return [
      objectToMap.minValue,
      objectToMap.maxValue,
      objectToMap.cycle ? 1 : 0
    ];
  }
}

class FootswitchEventMapper extends Mapper<List<int>, FootswitchEvent> {
  static const int byteSize = 13;

  @override
  FootswitchEvent mapTo(List<int> objectToMap) {
    //remove control byte (first and last)
    final configurationBytes = objectToMap.sublist(1, byteSize);
    return FootswitchEvent(
        EventTypeExtension.getByValue(configurationBytes[0]),
        configurationBytes[1],
        MidiTypeExtension.getByValue(configurationBytes[2]),
        configurationBytes[3],
        configurationBytes[4],
        configurationBytes[7],
        configurationBytes[8],
        midiValueOff: configurationBytes[5],
        positiveStep: configurationBytes[9] == 1,
        repeatIntervalMs: configurationBytes[6],
        stepValue: configurationBytes[10]);
  }

  @override
  List<int> mapFrom(FootswitchEvent objectToMap) {
    return [
      0x80,
      objectToMap.eventType.value,
      objectToMap.midiChannel,
      objectToMap.midiType.value,
      objectToMap.midiNumber,
      objectToMap.midiValueOn,
      objectToMap.midiValueOff ?? -1,
      objectToMap.repeatIntervalMs ?? -1,
      objectToMap.groupIndex,
      objectToMap.internalValueIndex,
      objectToMap.positiveStep ?? false ? 1 : 0,
      objectToMap.stepValue ?? 0,
      0x88
    ];
  }
}

class FootswitchConfigurationMapper
    extends Mapper<List<int>, FootswitchConfiguration> {
  static const int byteSize = FootswitchEventMapper.byteSize * 2;
  final FootswitchEventMapper _footswitchEventMapper = FootswitchEventMapper();

  @override
  List<int> mapFrom(FootswitchConfiguration objectToMap) {
    return _footswitchEventMapper.mapFrom(objectToMap.tapConfiguration) +
        _footswitchEventMapper.mapFrom(objectToMap.holdConfiguration);
  }

  @override
  FootswitchConfiguration mapTo(List<int> objectToMap) {
    return FootswitchConfiguration(
        _footswitchEventMapper
            .mapTo(objectToMap.sublist(0, FootswitchEventMapper.byteSize)),
        _footswitchEventMapper
            .mapTo(objectToMap.sublist(FootswitchEventMapper.byteSize)));
  }
}
