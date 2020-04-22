import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/Models/transaction.dart';
import 'package:urawai_pos/Pages/mainPage.dart';
import 'package:urawai_pos/Provider/postedOrder_provider.dart';

class TransactionOrderProvider with ChangeNotifier {
  addTransactionOrder({
    @required dynamic stateProvider,
    @required PaymentStatus paymentStatus,
    @required PaymentType paymentType,
  }) {
    TransactionOrder _transactionOrder;
    var box = Hive.box<TransactionOrder>(MainPage.transactionBoxName);

    try {
      if (stateProvider is PostedOrderProvider) {
        _transactionOrder = TransactionOrder(
          id: stateProvider.postedOrder.id,
          cashierName: stateProvider.postedOrder.cashierName,
          date: stateProvider.postedOrder.orderDate,
          referenceOrder: stateProvider.postedOrder.refernceOrder,
          grandTotal: stateProvider.grandTotal,
          itemList: stateProvider.postedOrder.orderList,
          paymentStatus: paymentStatus,
          paymentType: paymentType,
        );
      }
      //Add to Hive Box
      box.put(_transactionOrder.id, _transactionOrder);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      print(
          'Order ID : ${_transactionOrder.id} telah berhasil di tambahkan dgn status ${_transactionOrder.paymentStatus}');
    }
  }
}
