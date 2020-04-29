import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';

class TransactionOrderProvider with ChangeNotifier {
  addTransactionOrder({
    @required dynamic stateProvider,
    @required PaymentStatus paymentStatus,
    @required PaymentType paymentType,
  }) {
    TransactionOrder _transactionOrder;
    var box = Hive.box<TransactionOrder>(POSPage.transactionBoxName);

    try {
      if (stateProvider is PostedOrderProvider) {
        _transactionOrder = TransactionOrder(
          id: stateProvider.postedOrder.id,
          cashierName: stateProvider.postedOrder.cashierName,
          date: stateProvider.postedOrder.dateTime,
          referenceOrder: stateProvider.postedOrder.refernceOrder,
          grandTotal: stateProvider.grandTotal,
          itemList: stateProvider.postedOrder.orderList,
          paymentStatus: paymentStatus,
          paymentType: paymentType,
        );
      } else if (stateProvider is OrderListProvider) {
        _transactionOrder = TransactionOrder(
          id: stateProvider.orderID,
          cashierName: stateProvider.cashierName,
          date: stateProvider.orderDate,
          referenceOrder: stateProvider.referenceOrder,
          grandTotal: stateProvider.grandTotal,
          itemList: stateProvider.orderlist,
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
