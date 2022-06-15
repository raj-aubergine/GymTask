import 'package:flutter/material.dart';

class Flag with ChangeNotifier {
  bool _flag = true;
  bool get flag => _flag;
  void setFlag(bool value) {
    _flag = value;
    notifyListeners();
  }

  bool _update = false;
  bool get update => _update;
  void setUpdate(bool value) {
    _update = value;
    notifyListeners();
  }
}

class Update with ChangeNotifier {
  bool _update = false;
  bool get update => _update;
  void setUpdate(bool value) {
    _update = value;
    notifyListeners();
  }
}
