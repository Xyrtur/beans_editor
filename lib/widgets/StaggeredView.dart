import 'index.dart';

class StaggeredGridPage extends StatefulWidget {
  final beansViewType;
  const StaggeredGridPage({Key key, this.beansViewType}) : super(key: key);

  @override
  _StaggeredGridPageState createState() => _StaggeredGridPageState();
}

class _StaggeredGridPageState extends State<StaggeredGridPage> {
  var sqlHelper = SQLHelper();

  List<Map<String, dynamic>> _allBeans = [];
  viewType beansViewType;

  @override
  void initState() {
    super.initState();
    this.beansViewType = widget.beansViewType;
  }

  @override
  void setState(fn) {
    super.setState(fn);
    this.beansViewType = widget.beansViewType;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _stagKey = GlobalKey();
    if (Centre.updateNeeded) retrieveAllBeans();

    return Container(
      child: Padding(
        padding: _paddingForView(context),
        child: StaggeredGridView.count(
          key: _stagKey,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          crossAxisCount: _colForStaggeredView(context),
          children: List.generate(_allBeans.length, (index) => _beanTileGen(index)),
          staggeredTiles: _tilesForView(),
        ),
      ),
    );
  }

  void retrieveAllBeans() {
    var _beanData = sqlHelper.selectAllBeans();
    _beanData.then((value) {
      setState(() {
        this._allBeans = value;
        Centre.updateNeeded = false;
      });
    });
  }

  List<StaggeredTile> _tilesForView() {
    return List.generate(_allBeans.length, (index) => StaggeredTile.fit(1));
  }

  BeanTile _beanTileGen(int i) {
    return BeanTile(Beans(
        _allBeans[i]["id"],
        _allBeans[i]["title"] == null ? "" : utf8.decode(_allBeans[i]["title"]),
        _allBeans[i]["content"] ?? "",
        DateTime.fromMillisecondsSinceEpoch(_allBeans[i]["date_created"] * 1000),
        DateTime.fromMillisecondsSinceEpoch(_allBeans[i]["date_last_edited"] * 1000)));
  }

  int _colForStaggeredView(BuildContext context) {
    if (widget.beansViewType == viewType.List) return 1;

    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double top_bottom = 8;
    if (width > 500) {
      padding = (width) * 0.05;
    } else {
      padding = 8;
    }
    return EdgeInsets.only(left: padding, right: padding, top: top_bottom, bottom: top_bottom);
  }
}
