//import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:swift_form/controller/Orderitem.dart';
//import 'package:tuple/tuple.dart';
import 'product.dart';
import '../controller/OrderformItem.dart';
import 'order.dart';
import 'package:swift_form/view/Orderform.dart';
import 'package:swift_form/controller/Orderitem.dart';
class Confirmbutton extends StatelessWidget {
  const Confirmbutton({Key? key, required this.p_id, required this.qty})
      : super(key: key);

  final String p_id;
  final String qty;
  final bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print(p_id);
        // print(qty);
       //productorder.add(Tuple2(double.parse(p_id),OrderItem(itemId: double.parse(p_id), quantity: double.parse(qty))));
    // print(productorder);
      },
      child: Container(
        height: 48,
        width: 164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(10)),
        child: const Text("Confirm Item"),
      ),
    );
  }
}

class RemoveButton extends StatelessWidget {
  RemoveButton({required this.k,required this.pId,required this.qty}) : super(key: k);

  final Key k;
  String pId;
  double qty;

  @override
  Widget build(BuildContext context) {
    var Item = Provider.of<OrderFormItem>(context);
OrderItemProvider orderitem = Provider.of<OrderItemProvider>(context);
 
    return InkWell(
      onTap: () {

        // print(itemindex);
        
        print(qty);
        orderitem.removeOrderItem(OrderItem(itemId: double.tryParse(pId) ?? 0, quantity: qty));
        Item.removeitem(k);
        print(orderitem.orderitems.length);

        //productorder.rem
        //productorder.remove(value.);

        //  Provider.of<OrderFormItem>(context,listen: false).removeitem(index);
      },
      child: Container(
        height: 48,
        width: 164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(10)),
        child: const Text("Remove Item"),
      ),
    );
  }
}

class Billtype extends StatefulWidget {
  const Billtype({Key? key}) : super(key: key);

  @override
  State<Billtype> createState() => _BilltypeState();
}

class _BilltypeState extends State<Billtype> {
  String dropdownvalue = "R";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 328,
      height: 54,
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(10),
        value: dropdownvalue,
        items: ["R", "B"].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        hint: const Text("R/B"),
        onChanged: (String? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        },
      ),
    );
  }
}

Widget item({required BuildContext context}) {
  String pId = "";
  double qty=0;
  List<Product> products =
      Provider.of<ProductProvider>(context, listen: false).products;
OrderItemProvider orderItemProvider = Provider.of<OrderItemProvider>(context, listen: false);
                 
  TextEditingController price = TextEditingController();
  //TextEditingController q=TextEditingController();
  final key = UniqueKey();
  return SizedBox(
    key: key,
    height: 300,
    child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Consumer<OrderItemProvider>(
  builder: (context,OrderItemProvider, child) {
    return SearchField<Product>(
              suggestions: products.where((product)=>!OrderItemProvider.orderitems.any((orderItem) => orderItem.itemId.toString()==product.id))
                  .map((e) => SearchFieldListItem<Product>(e.name,
                      item: e,
                      child: ListTile(
                          title: Text(e.name),
                          trailing: Text(e.price.toString()))))
                  .toList(),
              searchInputDecoration: InputDecoration(
                  hintText: "Item name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onSuggestionTap: (e) {
                price.text = "₹${e.item!.price}";
                pId = e.item!.id;
                   // print(orderItemProvider.orderitems);

              },
             );
                }
            )
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Quantity",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onChanged: (value) {
                    qty = double.parse(value);
                    orderItemProvider.addOrderItem(OrderItem(itemId: double.parse(pId), quantity: qty));
                 
                    //productorder.add(OrderItem(itemId: double.parse(pId), quantity: double.parse(qty)));
                    // // Check if item ID already exists in the list
                    // int existingIndex = productorder
                    //     .indexWhere((item) => item.item1 == double.parse(pId));

                    // if (existingIndex != -1) {
                    //   // Item ID already exists, update the quantity
                    //   final item = OrderItem(
                    //       itemId: double.parse(pId),
                    //       quantity: double.parse(qty));
                    //   final newlist = productorder.where(
                    //     (element) => element.item1 != double.parse(pId),
                    //   );
                    //   productorder.clear();
                    //   productorder.addAll(newlist);
                    //   productorder.add(Tuple2(item.itemId, item));
                    // }
                    // if (existingIndex == -1) {
                    //   // Item ID doesn't exist, add a new item
                    //   final item = OrderItem(
                    //       itemId: double.parse(pId),
                    //       quantity: double.parse(qty));
                    //   final newlist = productorder.where(
                    //     (element) => element.item1 != double.parse(pId),
                    //   );
                    //   productorder.clear();
                    //   productorder.addAll(newlist);
                    //   productorder.add(Tuple2(item.itemId, item));
                    // }
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: price,
                  decoration: InputDecoration(
                      hintText: "Price",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
          ],
        ),
        const Billtype(),
        Expanded(
          child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Confirmbutton(p_id: p_id,qty: qty),
                const SizedBox(width: 10),
                RemoveButton(k: key,pId: pId,qty: qty)
              ]),
        )
      ],
    ),
  );
}
// Widget updateitem()
// {

// }