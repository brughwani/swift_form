import 'dart:convert';
import 'package:http/http.dart';
List<OrderItem> orderItems =[];
class Order {
  final double customerId;
  final double customerDiscount;
  final List<OrderItem> orderItems;



  Order({
    required this.customerId,
    required this.customerDiscount,
    required this.orderItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_discount': customerDiscount,
      'order_items_attributes': orderItems.map((item) => item.toJson())
          .toList(),
    };
  }
  Future<void> CreateOrderForm(String c_id,String discount,List<OrderItem> orderItems,String authtoken)
  async {
    var url="http://10.0.2.2:3000/api/v1/order_forms";
    var url2="http://127.0.0.1:3000/api/v1/order_forms";
    //final List<OrderItem> orderItems =[];
    String body=jsonEncode({
      "customer_id":double.parse(c_id),
      "discount":double.parse(discount),
      'order_items_attributes': orderItems.map((item) => item.toJson()).toList(),
    });
    print(body);
    final Map<String, String>? headers = {
      'Authorization': authtoken,
      // Add any other required headers,
      'Content-Type':'application/json'
    };
    final response = await post(
      Uri.parse(url2),
      headers: headers,
       body:body,
    );

  }


}
class OrderItem {
  final double itemId;
  final double quantity;

  OrderItem({required this.itemId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
    };
  }
}