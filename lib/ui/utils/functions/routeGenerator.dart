import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/Transacation_history/detail_transaction.dart';
import 'package:urawai_pos/ui/Pages/Transacation_history/transaction_history.dart';
import 'package:urawai_pos/ui/Pages/payment_screen/addtional_itemOrder.dart';
import 'package:urawai_pos/ui/Pages/payment_screen/payment_screen.dart';
import 'package:urawai_pos/ui/Pages/payment_success/payment_success.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Pages/products/add_products.dart';
import 'package:urawai_pos/ui/Pages/transaction_report/transaction_report.dart';

class RouteGenerator {
  static Route<dynamic> onGenerate(settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case POSPage.routeName:
        return MaterialPageRoute(builder: (context) => POSPage());
        break;
      case PaymentScreen.routeName:
        return MaterialPageRoute(builder: (context) => PaymentScreen(args));
        break;
      case TransactionHistoryPage.routeName:
        return MaterialPageRoute(
            builder: (context) => TransactionHistoryPage());
        break;
      case AddProductPage.routeName:
        return MaterialPageRoute(builder: (context) => AddProductPage());
        break;
      case AddtionalItemOrderPage.routeName:
        return MaterialPageRoute(
            builder: (context) => AddtionalItemOrderPage(args));
        break;
      case PaymentSuccess.routeName:
        return MaterialPageRoute(builder: (context) {
          var generalProvider = Provider.of<GeneralProvider>(context);

          if (args is PostedOrderProvider) {
            return PaymentSuccess(
              state: args,
              itemList: args.postedOrder.orderList,
              pembayaran: args.finalPayment,
              kembali: args.finalPayment - args.grandTotal,
              paymentType: generalProvider.paymentType,
            );
          } else if (args is OrderListProvider) {
            return PaymentSuccess(
              state: args,
              itemList: args.orderlist,
              pembayaran: args.finalPayment,
              kembali: args.finalPayment - args.grandTotal,
              paymentType: generalProvider.paymentType,
            );
          }
          return _onErrorRoute();
        });

        break;
      case DetailTransactionPage.routeName:
        if (args is String)
          return MaterialPageRoute(
              builder: (context) => DetailTransactionPage(boxKey: args));
        break;
      case TransactionReport.routeName:
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
