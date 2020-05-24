import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';

class PostedOrderProvider with ChangeNotifier {
  PostedOrder _postedOrder;
  String _totalPayment = '';
  double _finalPayment = 0;
  double _vat = 0;
  String _cashierName = '';
  double _extraDiscount = 0;
  double _taxFinal = 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this._postedOrder.orderList != null)
      data['orderlist'] =
          this._postedOrder.orderList.map((d) => d.toJson()).toList();
    return data;
  }

  PostedOrder get postedOrder => _postedOrder;
  set postedorder(PostedOrder newValue) {
    _postedOrder = newValue;
  }

  double get finalPayment => _finalPayment;
  set finalPayment(double newValue) {
    _finalPayment = newValue;
    notifyListeners();
  }

  double get taxFinal => _taxFinal;

  double get vat => _vat;
  set setVat(double newValue) {
    _vat = newValue;
    // notifyListeners();
  }

  double get extraDicount => _extraDiscount;
  set extraDicount(double newValue) {
    _extraDiscount = newValue;
    notifyListeners();
  }

  String get totalPayment => _totalPayment;
  set totalPayment(String newValue) {
    _totalPayment = newValue;
    notifyListeners();
  }

  String get cashierName => _cashierName;
  set cashierName(String newValue) {
    _cashierName = newValue;
    notifyListeners();
  }

  // addItem(PostedOrder pOrder, OrderList orderList, {bool vat = false}) {
  //   int index = pOrder.orderList.indexWhere((element) =>
  //       element.productName == orderList.productName &&
  //       element.id == orderList.id);

  //   if (index == -1)
  //     pOrder.orderList.add(orderList);
  //   else {
  //     OrderList data = pOrder.orderList[index];
  //     data.id = orderList.id;
  //     data.note = orderList.note;
  //     data.productName = orderList.productName;
  //     data.price = orderList.price;
  //     data.quantity = data.quantity + 1;
  //     data.discount = orderList.discount;
  //   }
  //   if (vat == true)
  //     _vat = 0.1;
  //   else
  //     _vat = 0;

  //   notifyListeners();
  // }

  resetFinalPayment() {
    _totalPayment = '';
    _finalPayment = 0;
    //notifyListeners();
  }

  removeItemFromList(int index) {
    _postedOrder.orderList.removeAt(index);
    notifyListeners();
  }

  addNote(String newValue, int index) {
    _postedOrder.orderList[index].note = newValue;
    notifyListeners();
  }

  double get discountTotal {
    var hasDiscount = _postedOrder.orderList.where((item) {
      return item.discount != null && item.discount != 0;
    });

    double result = hasDiscount.fold(0, (prev, item) {
      //perlu dikonfirmasi apakah diskon berlakuk kelipatan
      return prev + ((item.price * (item.discount / 100)) * item.quantity);
    });

    return result + _extraDiscount;
    //just return value from db
    // return _postedOrder.discount;
  }

  double get subTotal {
    double _total = 0;
    double _subtotal = 0;

    _postedOrder.orderList.forEach((order) {
      _total = order.quantity * order.price;
      _subtotal = _subtotal + _total;
    });
    return _subtotal;
  }

  double get grandTotal {
    double _grandTotal = 0;
    double _subtotal = 0;

    _postedOrder.orderList.forEach((order) {
      _subtotal = order.quantity * order.price;
      _grandTotal = _grandTotal + _subtotal;
    });
    _subtotal = _grandTotal;
    _taxFinal = _subtotal * _vat;

    if (_vat != 0)
      _grandTotal = (_subtotal + _taxFinal) - discountTotal;
    else
      _grandTotal = _subtotal - discountTotal;

    //proses pembulatan kebawah
    _grandTotal = _grandTotal - (_grandTotal % 100);

    return _grandTotal;
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

  deletePostedOrder(String key) {
    Hive.box<PostedOrder>(POSPage.postedBoxName).delete(key);
  }
}
