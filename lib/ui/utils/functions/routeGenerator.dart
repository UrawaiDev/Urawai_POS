import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/payment_screen/payment_screen.dart';
import 'package:urawai_pos/ui/Pages/payment_success/payment_success.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';

class RouteGenerator {
  static Route<dynamic> onGenerate(settings) {
    final args = settings.arguments;
    print(settings.name);
    switch (settings.name) {
      case POSPage.routeName:
        return MaterialPageRoute(builder: (context) => POSPage());
        break;
      case PaymentScreen.routeName:
        return MaterialPageRoute(builder: (context) => PaymentScreen(args));
        break;
      case PaymentSuccess.routeName:
        return MaterialPageRoute(builder: (context) {
          if (args is PostedOrderProvider) {
            // var state = args as PostedOrderProvider;
            return PaymentSuccess(
                state: args,
                itemList: args.postedOrder.orderList,
                cashierName: args.cashierName,
                referenceOrder: args.postedOrder.refernceOrder,
                date: args.postedOrder.orderDate,
                orderID: args.postedOrder.id,
                pembayaran: args.finalPayment,
                kembali: args.finalPayment - args.grandTotal);
          } else if (args is OrderListProvider) {
            return PaymentSuccess(
              state: args,
              itemList: args.orderlist,
              cashierName: args.cashierName,
              referenceOrder: args.referenceOrder,
              date: args.orderDate,
              orderID: args.orderID,
              pembayaran: args.finalPayment,
              kembali: args.finalPayment - args.grandTotal,
            );
          }
          return _onErrorRoute();
        });

        break;
      default:
        //route error due to type order not found
        return _onErrorRoute();
    }
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
