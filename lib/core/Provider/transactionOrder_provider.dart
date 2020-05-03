import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';

class TransactionOrderProvider with ChangeNotifier {
  addTransactionOrder({
    @required dynamic stateProvider,
    @required PaymentStatus paymentStatus,
    @required PaymentType paymentType,
  }) {
    TransactionOrder _transactionOrder;
    var box = Hive.box<TransactionOrder>(TransactionOrder.boxName);

    try {
      if (stateProvider is PostedOrderProvider) {
        _transactionOrder = TransactionOrder(
          id: stateProvider.postedOrder.id,
          cashierName: stateProvider.postedOrder.cashierName,
          date: stateProvider.postedOrder.dateTime,
          referenceOrder: stateProvider.postedOrder.refernceOrder,
          discount: stateProvider.discountTotal,
          subtotal: stateProvider.subTotal,
          grandTotal: stateProvider.grandTotal,
          itemList: stateProvider.postedOrder.orderList,
          paymentStatus: paymentStatus,
          paymentType: paymentType,
          tender: stateProvider.finalPayment,
          change: paymentType == PaymentType.CASH
              ? stateProvider.finalPayment - stateProvider.grandTotal
              : 0,
        );
      } else if (stateProvider is OrderListProvider) {
        _transactionOrder = TransactionOrder(
          id: stateProvider.orderID,
          cashierName: stateProvider.cashierName,
          date: stateProvider.orderDate,
          referenceOrder: stateProvider.referenceOrder,
          discount: stateProvider.discountTotal,
          subtotal: stateProvider.subTotal,
          grandTotal: stateProvider.grandTotal,
          itemList: stateProvider.orderlist.toList(),
          paymentStatus: paymentStatus,
          paymentType: paymentType,
          tender: stateProvider.finalPayment,
          change: paymentType == PaymentType.CASH
              ? stateProvider.finalPayment - stateProvider.grandTotal
              : 0,
        );
      }
      //Add to Hive Box
      box.put(_transactionOrder.id, _transactionOrder);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      print(
          'Order ID : ${_transactionOrder.id} dgn jumlah item ${_transactionOrder.itemList.length} telah berhasil di tambahkan dgn status ${_transactionOrder.paymentStatus}');
    }
  }

  deleteTransaction(String key) {
    Hive.box<TransactionOrder>(TransactionOrder.boxName).delete(key);
    print('$key deleted');
    notifyListeners();
  }
}
