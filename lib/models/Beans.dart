import 'index.dart';

class Beans {
  int id;
  String title;
  String content;
  DateTime date_created;
  DateTime date_last_edited;

  Beans(this.id, this.title, this.content, this.date_created, this.date_last_edited);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      // dont need to send id as it autoincrements if added
      'title': utf8.encode(title),
      'content': content,
      'date_created': epochFromDate(date_created),
      'date_last_edited': epochFromDate(date_last_edited),
    };
    if (forUpdate) {
      data['id'] = id;
    }
    return data;
  }

  // Converting the date time object into int representing seconds passed after midnight 1st Jan, 1970 UTC
  int epochFromDate(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date_created': epochFromDate(date_created),
      'date_last_edited': epochFromDate(date_last_edited),
    }.toString();
  }
}
