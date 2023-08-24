import 'package:http/http.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class Product
{
  String name;
  String price;
  String id;
  Product({required this.name,required this.price,required this.id});
}

class ProductProvider with ChangeNotifier
{
  List<Product> products=[];
  void fetchproducts(String auth) async
  {
    final url = 'http://10.0.2.2:3000/api/v1/customers';
    final url2="http://127.0.0.1:3000/api/v1/items";
    final Map<String, String>? headers = {
      'Authorization': auth,
      // Add any other required headers,
      'Content-Type':'application/json'
    };
    try {
      Response response = (await get(Uri.parse(url2),headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //print(data);


        products = data.map((item) => Product(name:item['name'], price: item['price'].toString(),id:item['id'].toString())).toList();
        //print(_customers[0].name);



        notifyListeners();
      } else {
        throw Exception('Failed to fetch items');
      }
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }
}