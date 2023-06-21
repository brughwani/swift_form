import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:swift_form/model/itemwidget.dart';
class OrderFormItem with ChangeNotifier
{
  List<Widget> widgetlist=[];
  void addwidget()
  {
    widgetlist.add(item());
    notifyListeners();
  }
  void removeitem(Key uniqueKey)
  {
    widgetlist=widgetlist.where((element) => element.key!=uniqueKey).toList();
    notifyListeners();
  }
}