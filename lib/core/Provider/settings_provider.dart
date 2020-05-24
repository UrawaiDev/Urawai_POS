import 'package:flutter/foundation.dart';

class SettingProvider with ChangeNotifier {
  bool _taxActivated = false;

  bool get taxActivated => _taxActivated;
  set taxActivated(bool newValue) {
    _taxActivated = newValue;
    notifyListeners();
  }
}
