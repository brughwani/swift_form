import 'package:flutter/material.dart';

class ItemData extends ChangeNotifier {
  String _pId = "";
  double _qty = 0;
  double _disc=0;

  String get pId => _pId;
  double get qty => _qty;
  double get disc=> _disc;

  void updateValues(String newPId, double newQty,double newdisc) {
    _pId = newPId;
    _qty = newQty;
    _disc=newdisc;
    notifyListeners();
  }
}