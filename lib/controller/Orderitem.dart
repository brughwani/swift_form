import 'package:flutter/material.dart';
import '/model/order.dart';

class OrderItemProvider extends ChangeNotifier {
  List<OrderItem> orderitems = [];

  void addOrderItem(OrderItem orderItem) {
    
    orderitems.add(orderItem);
   
    // for (var i in orderItems) {
    //  print(i.itemId);
    //  print(i.quantity);
    // }

    notifyListeners();
  }

  void removeOrderItem(OrderItem orderItem) {
    //print(orderItem.itemId);
    // for (var i in orderItems) {
    //  print(i);
    // }

    // print(orderItems); //[]
    // print("-----");

    orderitems.removeWhere((element) => element.itemId == orderItem.itemId);
    //print(orderitems); //["Instance of orderItem"]
    notifyListeners();
  }
}
