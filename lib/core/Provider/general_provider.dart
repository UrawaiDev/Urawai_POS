import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/transaction.dart';

class GeneralProvider with ChangeNotifier {
  bool _isDrawerShow = false;
  bool _isLoading = false;
  List<DateTime> _selectedDate = List<DateTime>();
  PaymentType _paymentType = PaymentType.CASH;
  PaymentStatus _paymentStatus = PaymentStatus.PENDING;

  PaymentType get paymentType => _paymentType;
  set paymentType(PaymentType newValue) {
    _paymentType = newValue;
    notifyListeners();
  }

  PaymentStatus get paymentStatus => _paymentStatus;
  set paymentStatus(PaymentStatus newValue) {
    _paymentStatus = newValue;
    notifyListeners();
  }

  List<DateTime> get selectedDate => _selectedDate;
  set selectedDate(List<DateTime> newValue) {
    _selectedDate = [];
    for (var date in newValue) _selectedDate.add(date);
    notifyListeners();
  }

  bool get isDrawerShow => _isDrawerShow;
  set isDrawerShow(bool newValue) {
    _isDrawerShow = newValue;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }
}
