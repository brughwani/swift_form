class Customer {
  String name;
  String address;
  double discount;

  Customer({
    required this.name,
    required this.address,
    required this.discount,
  });
}

class CustomerData {
  List<Customer> customers;

  CustomerData({required this.customers});
}
