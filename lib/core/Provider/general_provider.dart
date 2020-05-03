import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/transaction.dart';

class GeneralProvider with ChangeNotifier {
  bool _isDrawerShow = true;
  DateTime _selectedDate;
  PaymentType _paymentType = PaymentType.CASH;

  PaymentType get paymentType => _paymentType;
  set paymentType(PaymentType newValue) {
    _paymentType = newValue;
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime newValue) {
    _selectedDate = newValue;
    notifyListeners();
  }

  bool get isDrawerShow => _isDrawerShow;
  set isDrawerShow(bool newValue) {
    _isDrawerShow = newValue;
    notifyListeners();
  }
}
