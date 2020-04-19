import 'package:flutter/material.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/postedOrder.dart';

class PostedOrderProvider with ChangeNotifier {
  PostedOrder _postedOrder;
  String _totalPayment = '';
  double _finalPayment = 0;
  double _change = 0;

  PostedOrder get postedOrder => _postedOrder;
  set postedorder(PostedOrder newValue) {
    _postedOrder = newValue;
  }

  double get finalPayment => _finalPayment;
  set finalPayment(double newValue) {
    _finalPayment = newValue;
    notifyListeners();
  }

  String get totalPayment => _totalPayment;
  set totalPayment(String newValue) {
    _totalPayment = newValue;
    notifyListeners();
  }

  get change => _change;
  set change(double newValue) {
    _change = newValue;
    notifyListeners();
  }

  addItem(PostedOrder pOrder, OrderList orderList) {
    pOrder.orderList.add(orderList);
    notifyListeners();
  }

  resetFinalPayment() {
    _totalPayment = '';
    _finalPayment = 0;
    //notifyListeners();
  }

  removeItemFromList(int index) {
    _postedOrder.orderList.removeAt(index);
    notifyListeners();
  }

  // TODO:Rounded ke bawah saat nilai desimal
  double getGrandTotal() {
    double _grandTotal = 0;
    double _tax = 0;
    double _subtotal = 0;

    _postedOrder.orderList.forEach((order) {
      _subtotal = order.quantity * order.price;
      _grandTotal = _grandTotal + _subtotal;
    });
    _subtotal = _grandTotal;

    _tax = _subtotal * 0.1;
    _grandTotal = _subtotal + _tax;
    return _grandTotal;
  }

  double getSubtotal() {
    double _total = 0;
    double _subtotal = 0;

    _postedOrder.orderList.forEach((order) {
      _total = order.quantity * order.price;
      _subtotal = _subtotal + _total;
    });
    return _subtotal;
  }

  incrementQuantity(int index) {
    if (_postedOrder.orderList[index].quantity <= 999) {
      _postedOrder.orderList[index].quantity++;
      notifyListeners();
    }
  }

  decrementQuantity(int index) {
    if (_postedOrder.orderList[index].quantity > 1) {
      _postedOrder.orderList[index].quantity--;
      notifyListeners();
    }
  }
}
