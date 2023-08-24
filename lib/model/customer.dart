import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Customer {
  String id;
  String name;
  String address;
  double discount;


  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.discount,
  });
}
class CustomerProvider with ChangeNotifier {
  List<Customer> customers = [];
  //List<Customer> get customers => _customers;

  void fetchCustomers(String auth) async {
    final url = 'http://10.0.2.2:3000/api/v1/customers';
    final url2="http://127.0.0.1:3000/api/v1/customers";
    final Map<String, String>? headers = {
      'Authorization': auth,
      // Add any other required headers,
      'Content-Type':'application/json'
    };
    try {
      http.Response response = await http.get(Uri.parse(url2),headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
       // print(data);


        customers = data.map((item) => Customer.new(id:item['id'].toString(),name:item['name'], address:item['address'],discount:item['discount'])).toList();
        //print(_customers[0].name);



        notifyListeners();
      } else {
        throw Exception('Failed to fetch customers');
      }
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }
}
