// ignore_for_file: constant_identifier_names

enum Mode { SERVER, CLIENT }

extension ModeExtension on Mode {
  int get value {
    switch (this) {
      case Mode.SERVER:
        return 1;
      case Mode.CLIENT:
        return 2;
    }
  }

  static Mode getModeFromValue(int value) {
    switch (value) {
      case 1:
        return Mode.SERVER;
      case 2:
        return Mode.CLIENT;
      default:
        return Mode.SERVER;
    }
  }
}
