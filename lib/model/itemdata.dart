import 'package:flutter/material.dart';

class ItemData extends ChangeNotifier {
  String _pId = "";
  double _qty = 0;
  double _disc=0;
  //String bill_type="";

  String get pId => _pId;
  double get qty => _qty;
  double get disc=> _disc;
//  String get billtype=>bill_type;

  void updateValues(String newPId, double newQty,double newdisc) {
    _pId = newPId;
    _qty = newQty;
    _disc=newdisc;
  //  bill_type=newbilltype;
    notifyListeners();
  }
}
class BillTypeProvider extends ChangeNotifier {
  String billType = ""; // Initial value

  void updateBillType(String newType) {
    billType = newType;
    notifyListeners(); // Notify listeners of change
  }
}