import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:uuid/uuid.dart';

class OrderListProvider with ChangeNotifier {
  final Uuid _uuid = Uuid();
  List<OrderList> orderlist = [];
  int _quantity = 1;
  double _finalPayment = 0;
  String _totalPayment = '';
  String _note = '-';

  String _orderID = '';
  DateTime _orderDate;
  String _cashierName = '';
  String _referenceOrder = '';

  double _extraDiscount = 0;

  String get orderID => _orderID;
  set orderID(String newValue) {
    _orderID = newValue;
    notifyListeners();
  }

  String get totalPayment => _totalPayment;
  set totalPayment(String newValue) {
    _totalPayment = newValue;
    notifyListeners();
  }

  String get note => _note;

  void addNote(String newValue, int index) {
    orderlist[index].note = newValue;
    notifyListeners();
  }

  String get cashierName => _cashierName;
  set cashierName(String newValue) {
    _cashierName = newValue;
    notifyListeners();
  }

  String get referenceOrder => _referenceOrder;
  set referenceOrder(String newValue) {
    _referenceOrder = newValue;
    notifyListeners();
  }

  DateTime get orderDate => _orderDate;
  set orderDate(DateTime newValue) {
    _orderDate = newValue;
    notifyListeners();
  }

  double get finalPayment => _finalPayment;
  set finalPayment(double newValue) {
    _finalPayment = newValue;
    notifyListeners();
  }

  int get quantity => _quantity;
  set quantity(int newValue) {
    _quantity = newValue;
    notifyListeners();
  }

  double get discountTotal {
    var hasDiscount = orderlist.where((item) {
      return item.discount != null && item.discount != 0;
    });

    double result = hasDiscount.fold(0, (prev, item) {
      //perlu dikonfirmasi apakah diskon berlakuk kelipatan
      return prev + ((item.price * (item.discount / 100)) * item.quantity);
    });

    return result + _extraDiscount;
  }

  double get extraDicount => _extraDiscount;
  set extraDicount(double newValue) {
    _extraDiscount = newValue;
    notifyListeners();
  }

  resetFinalPayment() {
    _totalPayment = '';
    _finalPayment = 0;
  }

  void addToList({Product item, String referenceOrder}) {
    int index = orderlist.indexWhere((data) {
      return data.productName == item.name && data.price == item.price;
    });

    //-1 item not found in orderlist
    if (index == -1) {
      orderlist.add(OrderList(
        id: _orderID,
        productName: item.name,
        price: item.price,
        dateTime: DateTime.now(),
        quantity: 1,
        referenceOrder: referenceOrder,
        discount: item.discount,
      ));
      notifyListeners();
    } else {
      int prevQty = orderlist[index].quantity;

      orderlist[index] = OrderList(
        id: _orderID,
        productName: item.name,
        price: item.price,
        dateTime: DateTime.now(),
        quantity: prevQty + 1, //tambahan dengan quantity sebelumnya
        referenceOrder: referenceOrder,
        discount: item.discount,
      );
      notifyListeners();
    }
  }

  void removeFromList(int index) {
    orderlist.removeAt(index);
    notifyListeners();
  }

  void incrementQuantity(int index) {
    if (orderlist[index].quantity <= 999) {
      orderlist[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (orderlist[index].quantity > 1) {
      orderlist[index].quantity--;
      notifyListeners();
    }
  }

  void createNewOrder() {
    _orderID = _uuid.v1().substring(0, 8).toUpperCase();
    _orderDate = DateTime.now();
    notifyListeners();
  }

  void resetOrderList() {
    orderlist.clear();
    _orderID = '';
    _orderDate = null;
    _cashierName = '';
    _referenceOrder = '';
    _totalPayment = '';
    _finalPayment = 0;
    _extraDiscount = 0;

    notifyListeners();
  }

  double get grandTotal {
    double _grandTotal = 0;
    double _tax = 0;
    double _subtotal = 0;

    orderlist.forEach((order) {
      _subtotal = order.quantity * order.price;
      _grandTotal = _grandTotal + _subtotal;
    });
    _subtotal = _grandTotal;

    _tax = _subtotal * 0.1;
    _grandTotal = (_subtotal + _tax) - discountTotal;

    //proses pembulatan kebawah
    _grandTotal = _grandTotal - (_grandTotal % 100);
    return _grandTotal;
  }

  double get subTotal {
    double _total = 0;
    double _subtotal = 0;

    orderlist.forEach((order) {
      _total = order.quantity * order.price;
      _subtotal = _subtotal + _total;
    });
    return _subtotal;
  }

  bool addPostedOrder(OrderListProvider orderlistState) {
    var orderBox = Hive.box<PostedOrder>(POSPage.postedBoxName);

    try {
      var hiveValue = PostedOrder(
        id: orderlistState.orderID,
        dateTime: orderlistState.orderDate,
        subtotal: orderlistState.subTotal,
        discount: orderlistState.discountTotal,
        grandTotal: orderlistState.grandTotal,
        orderList: orderlistState.orderlist.toList(),
        paidStatus: PaidStatus.UnPaid,
        cashierName: orderlistState.cashierName,
        refernceOrder: orderlistState.referenceOrder,
      );

      //SAVE TO DATABASE
      orderBox.put(orderlistState.orderID, hiveValue);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      print('save ${orderlistState.orderlist.length} Item(s) to DB');
    }
  }
}
