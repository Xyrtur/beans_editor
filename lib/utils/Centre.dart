import 'index.dart';

class Centre {
  static bool _updateNeeded;

  static final homeFontColor = Color(0xFF9cabff);
  static final borderColor = Color(0xFF3e5af3);
  static final bgNoteColor = Color(0xff000000);
  static final bgColor = Color(0xFf101010);
  static final cursorColor = Color(0xFF89c9b8);

  static init() {
    if (_updateNeeded == null) _updateNeeded = true;
  }

  static bool get updateNeeded {
    init();
    return _updateNeeded;
  }

  static set updateNeeded(value) => _updateNeeded = value;
}
