import 'index.dart';
import 'BeanPage.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beanseditor/bloc/title_bloc.dart';

enum viewType { List, Staggered }

class MainBeanPage extends StatefulWidget {
  @override
  _MainBeanPageState createState() => _MainBeanPageState();
}

class _MainBeanPageState extends State<MainBeanPage> {
  var beansViewType;
  @override
  void initState() {
    beansViewType = viewType.Staggered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Centre.bgNoteColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _newBeanTapped(context),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Centre.cursorColor,
        ),
        resizeToAvoidBottomPadding: false,
        body: NestedScrollView(
          headerSliverBuilder: (context, isInnerBoxScroll) {
            return [
              RoundedFloatingAppBar(
                elevation: 3,
                backgroundColor: Centre.bgColor,
                snap: true,
                leading: Image.asset(
                  'images/beans.png',
                  height: 40,
                  width: 40,
                ),
                actions: <Widget>[
                  Image.asset(
                    'images/beans.png',
                    height: 40,
                    width: 40,
                  ),
                ],
                floating: true,
                title: Center(
                  child: Text("Beans Editor",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFe4e4e4))),
                ),
              ),
            ];
          },
          body: SafeArea(
              child: Container(
                child: StaggeredGridPage(beansViewType: beansViewType),
              ),
              left: true,
              bottom: true,
              top: true,
              right: true),
        ));
  }

  void _newBeanTapped(BuildContext context) {
    var emptyBean = new Beans(-1, "", "", DateTime.now(), DateTime.now());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BlocProvider<TitleBloc>(create: (context) => TitleBloc(), child: BeanPage(emptyBean))));
  }
}
