import 'package:flutter/material.dart';
import 'package:urawai_pos/ui/Pages/Transacation_history/detail_transaction.dart';
import 'package:urawai_pos/ui/Pages/Transacation_history/transaction_history.dart';
import 'package:urawai_pos/ui/Pages/authentication/gateKeeper.dart';
import 'package:urawai_pos/ui/Pages/authentication/login_page.dart';
import 'package:urawai_pos/ui/Pages/authentication/signup_page.dart';
import 'package:urawai_pos/ui/Pages/payment_screen/addtional_itemOrder.dart';
import 'package:urawai_pos/ui/Pages/payment_screen/payment_screen.dart';
import 'package:urawai_pos/ui/Pages/payment_success/payment_success.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Pages/products/add_products.dart';
import 'package:urawai_pos/ui/Pages/products/edit_products.dart';
import 'package:urawai_pos/ui/Pages/products/list_products.dart';
import 'package:urawai_pos/ui/Pages/settings/search_printer.dart';
import 'package:urawai_pos/ui/Pages/settings/settings.dart';
import 'package:urawai_pos/ui/Pages/transaction_report/transaction_report.dart';

class RouteGenerator {
  static const String kRouteProductListPage = 'ProductListPage';
  static const String kRoutePOSPage = 'POS_Page';
  static const String kRoutePaymentScreen = 'Payment_Screen';
  static const String kRouteTransactionHistory = 'Transaction_History';
  static const String kRouteAddProductPage = 'Add_Product_Page';
  static const String kRouteEditProductPage = 'Edit_Product_Page';
  static const String kRouteAddtionalItemOrderPage = 'Addtional_Item_Page';
  static const String kRoutePaymentSuccessPage = 'Payment_Success_Page';
  static const String kRouteDetailTransaction = 'Detail_Transaction_Page';
  static const String kRouteTransactionReport = 'Transaction_Report_Page';
  static const String kRouteSettingsPage = 'Settings_Page';
  static const String kRouteSignUpPage = 'SignUp_Page';
  static const String kRouteGateKeeper = 'GateKeeper_Page';
  static const String kRouteLoginPage = 'Login_Page';
  static const String kRoutePrinterPage = 'Printer_Page';

  static Route<dynamic> onGenerate(settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case kRouteGateKeeper:
        return MaterialPageRoute(builder: (context) => GateKeeper());
        break;
      case kRouteLoginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
        break;
      case kRoutePrinterPage:
        return MaterialPageRoute(builder: (context) => SearchPrinterPage());
        break;

      case kRouteSignUpPage:
        return MaterialPageRoute(builder: (context) => SignUpPage());
        break;
      case kRoutePOSPage:
        return MaterialPageRoute(builder: (context) => POSPage());
        break;
      case kRoutePaymentScreen:
        return MaterialPageRoute(builder: (context) => PaymentScreen(args));
        break;
      case kRouteTransactionHistory:
        return MaterialPageRoute(
            builder: (context) => TransactionHistoryPage());
        break;
      case kRouteAddProductPage:
        return MaterialPageRoute(builder: (context) => AddProductPage());
        break;
      case kRouteEditProductPage:
        return MaterialPageRoute(builder: (context) => EditProductPage(args));
        break;
      case kRouteProductListPage:
        return MaterialPageRoute(builder: (context) => ProductListPage());
        break;
      case kRouteSettingsPage:
        return MaterialPageRoute(builder: (context) => SettingPage());
        break;

      case kRouteAddtionalItemOrderPage:
        return MaterialPageRoute(
            builder: (context) => AddtionalItemOrderPage(args));
        break;
      case kRoutePaymentSuccessPage:
        return MaterialPageRoute(builder: (context) {
          return PaymentSuccess(orderID: args);

          // if (args is PostedOrderProvider) {
          //   return PaymentSuccess(
          //     orderID: args.postedOrder.id,

          //   );
          // } else if (args is OrderListProvider) {
          //   return PaymentSuccess(
          //     orderID: args.orderID,

          //   );
          // }
          // return _onErrorRoute();
        });

        break;
      case kRouteDetailTransaction:
        if (args is String)
          return MaterialPageRoute(
              builder: (context) => DetailTransactionPage(boxKey: args));
        break;
      case kRouteTransactionReport:
        return MaterialPageRoute(builder: (context) => TransactionReport());
        break;
      default:
        //route error due to type order not found
        return _onErrorRoute();
    }
    return _onErrorRoute();
  }
}

_onErrorRoute() {
  return MaterialPageRoute(
      builder: (context) => Scaffold(
            body: Center(
              child: Text('Route Error'),
            ),
          ));
}
