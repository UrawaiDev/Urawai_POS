import 'package:flutter/material.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/postedOrder.dart';

class PostedOrderProvider with ChangeNotifier {
  PostedOrder _postedOrder;
  double _subTotal;

  get postedOrder => _postedOrder;
  set postedOrder(PostedOrder newValue) {
    _postedOrder = newValue;
  }

  addItem(PostedOrder pOrder, OrderList orderList) {
    pOrder.orderList.add(orderList);
    notifyListeners();
  }

  removeItemFromList(int index) {
    _postedOrder.orderList.removeAt(index);
    notifyListeners();
  }

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
