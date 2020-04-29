import 'package:flutter/material.dart';

class GeneralProvider with ChangeNotifier {
  bool _isDrawerShow = true;
  DateTime _selectedDate;
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int newValue) {
    _selectedIndex = newValue;
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
