import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urawai_pos/Pages/Models/orderList.dart';
import 'package:uuid/uuid.dart';

class OrderListProvider with ChangeNotifier {
  final Uuid _uuid = Uuid();
  List<OrderList> orderlist = [];
  double _grandTotal = 0;
  int _quantity = 1;

  String _orderID = '';
  String _orderDate = '';

  get orderID => _orderID;
  set orderID(String newValue) {
    _orderID = newValue;
    notifyListeners();
  }

  get orderDate => _orderDate;
  set orderDate(String newValue) {
    _orderDate = newValue;
    notifyListeners();
  }

  get grandTotal => _grandTotal;
  set grandTotal(double newValue) {
    _grandTotal = newValue;
    notifyListeners();
  }

  get quantity => _quantity;
  set quantity(int newValue) {
    _quantity = newValue;
    notifyListeners();
  }

  void addToList(OrderList list) {
    orderlist.add(list);
    notifyListeners();
  }

  void removeFromList(int index) {
    orderlist.removeAt(index);
    notifyListeners();
  }

  void incrementQuantity(int index) {
    orderlist[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    orderlist[index].quantity--;
    notifyListeners();
  }

  void createNewOrder() {
    _orderID = _uuid.v1().substring(0, 8);
    _orderDate = DateFormat.yMEd().add_jms().format(DateTime.now());
    notifyListeners();
  }

  void resetOrderList() {
    orderlist.clear();
    orderID = '';
    orderDate = '';
    notifyListeners();
  }
}
