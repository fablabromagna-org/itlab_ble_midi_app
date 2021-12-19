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
}
