import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Provider/settings_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/core/Services/connectivity_service.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

import 'core/Models/transaction.dart';

const String postedOrderBox = "Posted_Order";
const String transactionBoxName = "TransactionOrder";
const String settingsBoxName = "settingsBox";

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

  _loadAppConfig();

  runApp(MyApp());
}

void _loadAppConfig() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs.getBool('vat') == null)
    _prefs.setBool('vat', false);
  else
    print(' VAT from MAIN ${_prefs.getBool('vat')}');
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
        ChangeNotifierProvider(create: (context) => SettingProvider()),

        //not sure if this the best Practice
        StreamProvider<ConnectivityResult>(
            create: (context) =>
                ConnectivityService().networkStatusController.stream),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Urawai POS',
        theme: ThemeData(
            fontFamily: 'Sen',
            primaryColor: Color(0xFF408be5),
            scaffoldBackgroundColor: Color(0xFFfbfcfe),
            textTheme: TextTheme(body1: TextStyle(color: Color(0xFF435c72)))),
        initialRoute: 'POS_Page',
        onGenerateRoute: RouteGenerator.onGenerate,
      ),
    );
  }
}
