import 'index.dart';
import 'package:intl/intl.dart';

class Centre {
  static bool _updateNeeded;

  static final homeFontColor = Color(0xFFb7efcd);
  static final borderColor = Color(0xffffbcbc);
  static final bgNoteColor = Color(0xff000000);
  static final bgColor = Color(0xFF1f1f1f);
  static final cursorColor = Color(0xFF89c9b8);

  static init() {
    if (_updateNeeded == null) _updateNeeded = true;
  }

  static bool get updateNeeded {
    init();
    return _updateNeeded;
  }

  static set updateNeeded(value) => _updateNeeded = value;

  static String dateTimeToString(DateTime dt) {
    DateTime dtLocal = dt.toLocal();
    DateTime now = DateTime.now().toLocal();
    String dateString = "Edited ";

    var diff = now.difference(dtLocal);
    if (now.day == dtLocal.day) {
      // creates format like: 12:35 PM,
      var todayFormat = DateFormat("h:mm a");
      dateString += todayFormat.format(dtLocal);
    } else if ((diff.inDays) == 1 || (diff.inSeconds < 86400 && now.day != dtLocal.day)) {
      var yesterdayFormat = DateFormat("h:mm a");
      dateString += "Yesterday, " + yesterdayFormat.format(dtLocal);
    } else if (now.year == dtLocal.year && diff.inDays > 1) {
      var monthFormat = DateFormat("MMM d");
      dateString += monthFormat.format(dtLocal);
    } else {
      var yearFormat = DateFormat("MMM d y");
      dateString += yearFormat.format(dtLocal);
    }

    return dateString;
  }
}
