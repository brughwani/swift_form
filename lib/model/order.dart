import 'dart:convert';
import 'package:http/http.dart';
//import 'package:flutter/material.dart';
import 'package:swift_form/config/config.dart';
List<OrderItem> orderItems =[];
class Order {
  final double customerId;
  final String comments;
  //final String tax_type;
 //final double customerDiscount;
  final List<OrderItem> orderItems;



  Order( {
    required this.customerId,
    required this.comments,
    
   // required this.customerDiscount,
    required this.orderItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      //'customer_discount': customerDiscount,
      'order_items_attributes': orderItems.map((item) => item.toJson())
          .toList(),
    };
  }
  Future<void> CreateOrderForm(String c_id,String discount,List<OrderItem> orderItems,String authtoken)
  async {
    var url="http://10.0.2.2:3000/api/v1/order_forms";
    var url2="http://127.0.0.1:3000/api/v1/order_forms";
    var url3="${Config.getBaseUrl}/api/v1/order_forms";
    //final List<OrderItem> orderItems =[];
    String body=jsonEncode({
      "customer_id":double.parse(c_id),
    //  "discount":double.tryParse(discount) ?? 0,
      'order_items_attributes': orderItems.map((item) => item.toJson()).toList(),
    });
    print(body+"1");
    final Map<String, String>? headers = {
      'Authorization': authtoken,
      // Add any other required headers,
      'Content-Type':'application/json'
    };
    final response = await post(
      Uri.parse(url3),
      headers: headers,
       body:body,
    );

  }


}
class OrderItem {
  final double itemId;
  final double quantity;
  final double discount;
  final String tax_type;

  OrderItem({required this.itemId, required this.quantity,required this.discount,required this.tax_type});

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
      'discount':discount,
      'tax_type':tax_type

    };
  }
}
