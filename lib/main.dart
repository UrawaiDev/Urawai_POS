import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Pages/postedOrderList.dart';
import 'package:urawai_pos/Provider/general_provider.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:urawai_pos/Provider/postedOrder_provider.dart';

import 'Pages/mainPage.dart';

const String postedOrderBox = "Posted_Order";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  var appPath = await path.getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  Hive.registerAdapter<PostedOrder>(PostedOrderAdapter());
  Hive.registerAdapter<PaidStatus>(PaidStatusAdapter());
  Hive.registerAdapter<OrderList>(OrderListAdapter());
  await Hive.openBox<PostedOrder>(postedOrderBox);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderListProvider()),
        ChangeNotifierProvider(create: (context) => GeneralProvider()),
        ChangeNotifierProvider(create: (context) => PostedOrderProvider()),
      ],
      child: MaterialApp(
          title: 'Urawai POS',
          theme: ThemeData(
              fontFamily: 'Sen',
              primaryColor: Color(0xFF408be5),
              scaffoldBackgroundColor: Color(0xFFfbfcfe),
              textTheme: TextTheme(body1: TextStyle(color: Color(0xFF435c72)))),
          home: MainPage(),
          routes: {
            '/postedOrderList ': (context) => PostedOrderList(),
            // '/paymentScreen': (context) => PaymentScreen(),
          }),
    );
  }
}
