import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

import 'core/Models/transaction.dart';

const String postedOrderBox = "Posted_Order";
const String transactionBoxName = "TransactionOrder";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  var appPath = await path.getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  Hive.registerAdapter<PostedOrder>(PostedOrderAdapter());
  Hive.registerAdapter<PaidStatus>(PaidStatusAdapter());
  Hive.registerAdapter<OrderList>(OrderListAdapter());
  Hive.registerAdapter<TransactionOrder>(TransactionOrderAdapter());
  Hive.registerAdapter<PaymentStatus>(PaymentStatusAdapter());
  Hive.registerAdapter<PaymentType>(PaymentTypeAdapter());
  await Hive.openBox<PostedOrder>(postedOrderBox);
  await Hive.openBox<TransactionOrder>(transactionBoxName);

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
        ChangeNotifierProvider(create: (context) => TransactionOrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Urawai POS',
        theme: ThemeData(
            fontFamily: 'Sen',
            primaryColor: Color(0xFF408be5),
            scaffoldBackgroundColor: Color(0xFFfbfcfe),
            textTheme: TextTheme(body1: TextStyle(color: Color(0xFF435c72)))),
        initialRoute: '/pos',
        onGenerateRoute: RouteGenerator.onGenerate,
      ),
    );
  }
}
