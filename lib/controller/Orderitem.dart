import 'package:flutter/material.dart';
import '/model/order.dart';

class OrderItemProvider extends ChangeNotifier {
  List<OrderItem> orderitems = [];

  void addOrderItem(OrderItem orderItem) {
    print(orderitems.length);
    orderitems.add(orderItem);
    print(orderitems.length);
    print("#######");
    //print(orderitems);
    //print(1);
    notifyListeners();
  }

  void removeOrderItem(OrderItem orderItem) {
    print(orderItem.itemId);
    for (var i in orderItems) {
     print(i);
    }

    print(orderItems); //[]
    print("-----");

    orderitems.removeWhere((element) => element.itemId == orderItem.itemId);
    print(orderitems); //["Instance of orderItem"]
    notifyListeners();
  }
}
