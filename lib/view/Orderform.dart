import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:swift_form/controller/OrderformItem.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:swift_form/model/customer.dart';
import 'package:searchfield/searchfield.dart';
import 'package:swift_form/model/product.dart';
import 'package:swift_form/model/order.dart';
import 'package:swift_form/controller/Orderitem.dart';
//import 'package:tuple/tuple.dart';

//final TextEditingController searchController = TextEditingController();
TextEditingController village = TextEditingController();
TextEditingController comments= TextEditingController();

TextEditingController discount = TextEditingController();
//String _searchText = '';
//Customer? selectedCustomer;
String c_id="";
String item_id = "";
String selectedquantity = "";
//List<OrderItem> productorder = [];
int productid = 0;
//List<Map<int, OrderItem>> productorderlist = [];

class Confirmlist extends StatefulWidget {
  const Confirmlist({Key? key, required this.authtoken}) : super(key: key);
  final String authtoken;

  @override
  State<Confirmlist> createState() => _ConfirmlistState();
}

class _ConfirmlistState extends State<Confirmlist> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
     var orderItemProvider = Provider.of<OrderItemProvider>(context);
    var orderitems = orderItemProvider.orderitems;
     var orderFormItem = Provider.of<OrderFormItem>(context);
    var widgetList = orderFormItem.widgetlist;

    //print(c_id+"1");
    
    Order order = Order(
  customerId: double.tryParse(c_id) ?? 0,
  comments: comments.text,
  //customerDiscount: double.tryParse(discount.text) ?? 0,
  orderItems: orderitems,
);

    return InkWell(
      onTap: () {
//CreateOrderForm(c_id,discount.text)
//print(orderitems);
        order.CreateOrderForm(c_id,comments.text,
            orderitems, widget.authtoken);
        setState(() {
          isPressed = true;
        });

        Navigator.pop(context);
      
      orderitems.clear();
      widgetList.clear();
      },
      child: Container(
        height: 48,
        width: 328,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isPressed ? Colors.grey : Colors.amberAccent,
            borderRadius: BorderRadius.circular(10)),
        child: const Text("Confirm Order"),
      ),
    );
  }
}

class OrderForm extends StatefulWidget {
  const OrderForm({Key? key, required this.authtoken}) : super(key: key);

  final String authtoken;

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  @override
  void initState() {
    super.initState();
    //searchController.addListener(()=>onSearchTextChanged(searchController.text.toLowerCase()));
    Provider.of<CustomerProvider>(context, listen: false)
        .fetchCustomers(widget.authtoken);
    Provider.of<ProductProvider>(context, listen: false)
        .fetchproducts(widget.authtoken);
  }

  @override
  Widget build(BuildContext context) {
    List<Customer> customers = Provider.of<CustomerProvider>(context).customers;

    return Consumer<OrderFormItem>(builder: (context, state, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Image(
              image: AssetImage("assets/Frame 44.png"),
              width: 176,
              height: 36,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    color: Colors.amberAccent,
                    height: 96,
                    width: MediaQuery.of(context).size.width,
                    child: const Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(94, 12, 95, 57),
                        child: Text(
                          "CREATE ORDER FORM",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),

                    ])),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: SearchField<Customer>(
                    suggestions: customers
                        .map((e) => SearchFieldListItem<Customer>(e.name,
                            item: e,
                            child: ListTile(
                                title: Text(e.name),
                                trailing: Text(e.address))))
                        .toList(),
                    searchInputDecoration: InputDecoration(
                        hintText: "Customer name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onSuggestionTap: (e) {
                      c_id = e.item!.id;
                      village.text = e.item!.address;
                      //discount.text = e.item!.discount.toString();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    controller: village,
                    decoration: InputDecoration(
                        hintText: "Village",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                //   child: TextField(
                //     controller: discount,
                //     decoration: InputDecoration(
                //         hintText: "Customer Discount",
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10))),
                //   ),
                // ),
                ...state.widgetlist,
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: InkWell(
                    onTap: () {
                      state.addwidget(context);

                      //productid++;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all()),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline),
                          Text("Add Item")
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    controller: comments,
                    decoration: InputDecoration(
                        hintText: "Note/Scheme",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Confirmlist(authtoken: widget.authtoken)
              ],
            ),
          ));
    });
  }
}
