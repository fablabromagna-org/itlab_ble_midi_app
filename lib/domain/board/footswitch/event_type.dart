// ignore_for_file: constant_identifier_names
enum EventType { SINGLE, REPEAT, INCREMENT, ON_OFF }

extension EventTypeExtension on EventType {
  int get value {
    int value = 1;
    switch (this) {
      case EventType.SINGLE:
        value = 1;
        break;
      case EventType.REPEAT:
        value = 2;
        break;
      case EventType.INCREMENT:
        value = 3;
        break;
      case EventType.ON_OFF:
        value = 4;
        break;
    }
    return value;
  }

  static EventType getByValue(int value) {
    EventType mode;
    switch (value) {
      case 1:
        mode = EventType.SINGLE;
        break;
      case 2:
        mode = EventType.REPEAT;
        break;
      case 3:
        mode = EventType.INCREMENT;
        break;
      case 4:
        mode = EventType.ON_OFF;
        break;
      default:
        mode = EventType.SINGLE;
        break;
    }
    return mode;
  }
}
