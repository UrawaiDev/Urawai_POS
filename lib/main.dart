import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Pages/mainPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urawai POS',
      theme: ThemeData(
          fontFamily: 'Sen',
          primaryColor: Color(0xFF408be5),
          scaffoldBackgroundColor: Color(0xFFfbfcfe),
          textTheme: TextTheme(body1: TextStyle(color: Color(0xFF435c72)))),
      home: MainPage(),
    );
  }
}
