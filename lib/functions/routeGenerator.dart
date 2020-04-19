import 'package:flutter/material.dart';
import 'package:urawai_pos/Pages/mainPage.dart';
import 'package:urawai_pos/Pages/payment_screen_draftOrder.dart';
import 'package:urawai_pos/Pages/payment_success.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';
import 'package:urawai_pos/Provider/postedOrder_provider.dart';

class RouteGenerator {
  static Route<dynamic> onGenerate(settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MainPage());
        break;
      case PaymentScreenDraftOrder.routeName:
        return MaterialPageRoute(
            builder: (context) => PaymentScreenDraftOrder(args));
        break;
      case PaymentSuccess.routeName:
        return MaterialPageRoute(builder: (context) {
          if (args is PostedOrderProvider) {
            // var state = args as PostedOrderProvider;
            return PaymentSuccess(
                itemList: args.postedOrder.orderList,
                cashierName: 'Kasir Dummy (Posted Order)',
                date: args.postedOrder.orderDate,
                orderID: args.postedOrder.id,
                pembayaran: args.finalPayment,
                kembali: args.finalPayment - args.getGrandTotal());
          } else if (args is OrderListProvider) {
            return PaymentSuccess(
              itemList: args.orderlist,
              cashierName: 'Kasir Dummy (OrderList)',
              date: args.orderDate,
              orderID: args.orderID,
              pembayaran: 0, //temporary value
              kembali: 0, //temporary value
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
