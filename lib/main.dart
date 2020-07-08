import 'package:beanseditor/screens/index.dart';
import 'package:flutter/material.dart';
import 'screens/MainBeanPage.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        iconTheme: IconThemeData(color: Centre.homeFontColor),
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
        ),
      ),
      home: MainBeanPage(),
    );
  }
}
