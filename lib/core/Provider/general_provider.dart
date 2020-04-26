import 'package:flutter/material.dart';

class GeneralProvider with ChangeNotifier {
  bool _isDrawerShow = true;

  get isDrawerShow => _isDrawerShow;
  set isDrawerShow(bool newValue) {
    _isDrawerShow = newValue;
    notifyListeners();
  }
}
