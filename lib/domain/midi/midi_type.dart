// ignore: constant_identifier_names
enum MidiType { CC, PC }

extension MidiTypeExtension on MidiType {
  int get value {
    switch (this) {
      case MidiType.CC:
        return 1;
      case MidiType.PC:
        return 2;
    }
  }

  static MidiType getByValue(int value) {
    switch (value) {
      case 1:
        return MidiType.CC;
      case 2:
        return MidiType.PC;
      default:
        return MidiType.CC;
    }
  }
}
