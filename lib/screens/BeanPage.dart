import 'package:beanseditor/utils/SQLHelper.dart';

import 'index.dart';

class BeanPage extends StatefulWidget {
  final Beans beanInEditing;

  BeanPage(this.beanInEditing);
  @override
  _BeanPageState createState() => _BeanPageState();
}

class _BeanPageState extends State<BeanPage> {
  final _titleController = TextEditingController();
  ZefyrController _contentController;

  bool _isNewNote = false;
  FocusNode _contentFocus = FocusNode();
  final _titleFocus = FocusNode();

  String _titleInitial;
  String _contentInitial;
  DateTime _lastEditedForUndo;

  var _editableBean;

  Timer _persistenceTimer; //timer variable calls persistData every 5seconds and cancels timer when page pops

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _editableBean = widget.beanInEditing;
    _titleController.text = _editableBean.title;
    _contentController = (_editableBean.content == ""
        ? ZefyrController(NotusDocument())
        : ZefyrController(NotusDocument.fromJson(jsonDecode(_editableBean.content))));
    _lastEditedForUndo = _editableBean.date_last_edited;

    _contentInitial = _editableBean.content;
    _titleInitial = _editableBean.title;

    if (_editableBean.id == -1) {
      _isNewNote = true;
    }

    _persistenceTimer = new Timer.periodic(Duration(seconds: 5), (timer) {
      _persistData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_editableBean.id == -1 && _editableBean.content.isEmpty) {
      FocusScope.of(context).requestFocus(_titleFocus);
    }

    return WillPopScope(
      child: Scaffold(
          backgroundColor: Centre.bgNoteColor,
          key: _globalKey,
          resizeToAvoidBottomPadding: false,
          body: NestedScrollView(
            headerSliverBuilder: (context, isInnerBoxScroll) {
              return [
                RoundedFloatingAppBar(
                  elevation: 3,
                  backgroundColor: Centre.bgColor,
                  snap: true,
                  floating: true,
                  actions: _actions(context),
                  leading: BackButton(color: Centre.homeFontColor),
                  title: _pageTitle(),
                ),
              ];
            },
            body: _body(context),
          )),
      onWillPop: _readyToPop,
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      color: Centre.bgNoteColor,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: EditableText(
                    onChanged: (str) => updateBean(),
                    maxLines: null,
                    controller: _titleController,
                    focusNode: _titleFocus,
                    style: TextStyle(
                      color: Centre.homeFontColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                    cursorColor: Centre.cursorColor,
                    backgroundCursorColor: Centre.cursorColor,
                  ),
                ),
              ),
              Divider(color: Centre.cursorColor),
              Flexible(
                child: Container(
//                  padding: EdgeInsets.all(5),
                  child: new DefaultTextStyle(
                    style: new TextStyle(
                      inherit: true,
                      color: Colors.white,
                      fontFamily: 'RobotoMono',
                    ),
                    child: ZefyrScaffold(
                      child: ZefyrEditor(
                        controller: _contentController,
                        focusNode: _contentFocus,
                        keyboardAppearance: Brightness.dark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          left: true,
          right: true,
          top: false,
          bottom: false),
    );
  }

  void _persistData() {
    updateBean();

    if (_editableBean.content.isNotEmpty) {
      var sqlHelper = SQLHelper();

      if (_editableBean.id == -1) {
        Future<int> autoIncrId = sqlHelper.insertBean(_editableBean, true); // new note
        autoIncrId.then((value) => _editableBean.id = value);
      } else {
        sqlHelper.insertBean(_editableBean, false); //just updatin
      }
    }
  }

  List<Widget> _actions(BuildContext context) {
    List<Widget> actions = [];
    if (_editableBean.id != -1) {
      actions.add(Padding(
        padding: EdgeInsets.only(left: 6),
        child: IconButton(
          icon: Icon(
            Icons.blur_on,
            color: Centre.homeFontColor,
          ),
          onPressed: () {},
        ),
      ));
    }
    actions += [
      Padding(
        padding: EdgeInsets.only(left: 6),
        child: IconButton(
          icon: Icon(
            Icons.save,
            color: Centre.homeFontColor,
          ),
          onPressed: () {
            _persistData();
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 6),
        child: IconButton(
          icon: Icon(
            Icons.delete,
            color: Centre.homeFontColor,
          ),
          onPressed: () {
            _delete(context);
          },
        ),
      ),
    ];
    return actions;
  }

  Widget _pageTitle() => Text(
        _editableBean == -1 ? "New Bean" : "Edit Bean",
        style: TextStyle(color: Colors.white),
      );

  void updateBean() {
    _editableBean.content = jsonEncode(_contentController.document);
    _editableBean.title = _titleController.text;
    print('ok so like what the fuck is shit thesame:  ${_editableBean.content == _contentInitial}');
    if (!(_editableBean.title == _titleInitial && _editableBean.content == _contentInitial) || (_isNewNote)) {
      // if changes to note or if new note, change the date last edited
      print('yeah?');
      _editableBean.date_last_edited = DateTime.now();
      Centre.updateNeeded = true;
    }
  }

  void _undo() {
    //undos shit back to the v beginning todo change the undo function to just rollback to the last 5 second update
    _titleController.text = _titleInitial;
    _contentController = ZefyrController(NotusDocument.fromJson(jsonDecode(_contentInitial)));
    _editableBean.date_last_edited = _lastEditedForUndo;
  }

  void _delete(BuildContext context) {
    if (_editableBean.id != -1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Centre.bgColor,
              title: Text(
                "Confirm?",
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              content: Text(
                "cant go back on that shit chief",
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      _persistenceTimer.cancel();
                      var sqlHelper = SQLHelper();
                      Navigator.of(context).pop();
                      sqlHelper.deleteBean(_editableBean);
                      Centre.updateNeeded = true;
                      Navigator.of(context).pop();
                    },
                    child: Text("yuh")),
                FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text("nah"))
              ],
            );
          });
    }
  }

  Future<bool> _readyToPop() async {
    _persistenceTimer.cancel();
    _persistData();
    return true;
  }
}
