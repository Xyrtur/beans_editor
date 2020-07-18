import 'package:beanseditor/models/index.dart';
import 'package:beanseditor/screens/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beanseditor/bloc/title_bloc.dart';

import 'index.dart';

class BeanTile extends StatefulWidget {
  final Beans bean;
  BeanTile(this.bean);
  @override
  _BeanTileState createState() => _BeanTileState();
}

class _BeanTileState extends State<BeanTile> {
  String _content;
  double _fontSize;
  final tileColor = Centre.bgNoteColor;
  String title;

  @override
  Widget build(BuildContext context) {
    _content = widget.bean.content;
    _fontSize = _fontSizeForContent();
    title = widget.bean.title;

    return GestureDetector(
      onTap: () => _beanTapped(context),
      child: Container(
          height: 150,
          decoration: BoxDecoration(
              border: Border.all(color: Centre.borderColor),
              color: Centre.bgColor,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: EdgeInsets.all(8),
          child: makeThatBEAN()),
    );
  }

  Widget makeThatBEAN() {
    List<Widget> beanContents = [];

    if (widget.bean.title.length != 0) {
      beanContents.add(
        AutoSizeText(
          title,
          style: TextStyle(color: Centre.homeFontColor, fontSize: _fontSize, fontWeight: FontWeight.bold),
          maxLines: widget.bean.title.length == 0 ? 1 : 3,
          textScaleFactor: 1.5,
        ),
      );
      beanContents.add(Divider(color: Colors.transparent, height: 6));
    }
    beanContents.add(Expanded(
      child: ListView(shrinkWrap: true, children: [
        new DefaultTextStyle(
            style: new TextStyle(
              inherit: true,
              color: Colors.white,
              fontFamily: 'RobotoMono',
            ),
            child: ZefyrView(document: NotusDocument.fromJson(jsonDecode(widget.bean.content))))
      ]),
    ));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: beanContents);
  }

  void _beanTapped(BuildContext context) {
    Centre.updateNeeded = false;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BlocProvider<TitleBloc>(create: (context) => TitleBloc(), child: BeanPage(widget.bean))));
  }

  double _fontSizeForContent() {
    int charCount = _content.length + widget.bean.title.length;
    double fontSize = 15;
    if (charCount > 110) {
      fontSize = 10;
    } else if (charCount > 80) {
      fontSize = 11;
    } else if (charCount > 50) {
      fontSize = 12;
    } else if (charCount > 20) {
      fontSize = 13;
    }

    return fontSize;
  }
}
