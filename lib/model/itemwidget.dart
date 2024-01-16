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
//import 'package:swift_form/controller/Orderitem.dart';
import 'itemdata.dart';
 String pId = "";
  double qty=0;
  double disc=0;
  String bill_type="R";
class Confirmbutton extends StatefulWidget {
   Confirmbutton({Key? key,required String pId,required double qty,required double disc})
      : super(key: key);


 
  @override
  State<Confirmbutton> createState() => _ConfirmbuttonState();
}

class _ConfirmbuttonState extends State<Confirmbutton> {
  //final bool isPressed = false;
  Color _buttonColor = Colors.amber;

  @override
  Widget build(BuildContext context) {
    OrderItemProvider orderitem = Provider.of<OrderItemProvider>(context);
    String billType = Provider.of<BillTypeProvider>(context).billType;
    
    // final itemData = Provider.of<ItemData>(context);
    // double qty = itemData.qty;
    // String pId = itemData.pId;

 
    return InkWell(
      onTap: () {
         //  print(2);
       // print(bill_type);

        setState(() {
_buttonColor=Colors.grey;
        });
         orderitem.addOrderItem(OrderItem(itemId: double.tryParse(pId) ?? 0,tax_type:billType, quantity: qty,discount: disc));
      //  print(pId);
      

 //itemData.updateValues(pId,qty);
         
// print(oI.itemId);
        // print(widget.p_id);
        // print(widget.qty);
       // print(qty);
       //productorder.add(Tuple2(double.parse(p_id),OrderItem(itemId: double.parse(p_id), quantity: double.parse(qty))));
    // print(productorder);
      },
      child: Container(
        height: 48,
        width: 164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _buttonColor, borderRadius: BorderRadius.circular(10)),
        child: const Text("Confirm Item"),
      ),
    );
  }
}

class RemoveButton extends StatelessWidget {
  RemoveButton({required this.k}) : super(key: k);

  final Key k;
  
  @override
  Widget build(BuildContext context) {
    var Item = Provider.of<OrderFormItem>(context);
OrderItemProvider orderitem = Provider.of<OrderItemProvider>(context);
 final itemData = Provider.of<ItemData>(context);
    
    return InkWell(
      onTap: () {
      
OrderItem oi=OrderItem(itemId: double.tryParse(itemData.pId) ?? 0,tax_type: bill_type ,quantity: itemData.qty,discount: itemData.disc);
        // print(itemindex);
        
        //print(qty);

        orderitem.removeOrderItem(oi);
        Item.removeitem(k);
        //print(orderitem.orderitems.length);

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
  //String 
  @override
  Widget build(BuildContext context) {
    //
    var billtypeprovider= Provider.of<BillTypeProvider>(context,listen: false);
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
           // bill_type = newValue!;
          });
          billtypeprovider.updateBillType(dropdownvalue);
     
           
        },
      ),
    );
  }
}

Widget item({required BuildContext context}) {
  final itemData = Provider.of<ItemData>(context, listen: false);
  //final key1 = ValueKey<String>(pId);
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
              suggestions: products.map((e) => SearchFieldListItem<Product>(e.name,
                      item: e,
                      child: ListTile(
                        //key: key1,
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
               // print(pId);
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
                    qty = double.tryParse(value) ?? 0;
                    
                    //print(qty);
                   // orderItemProvider.addOrderItem(OrderItem(itemId: double.parse(pId), quantity: qty));
                 
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
              Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: discount,
                  decoration: InputDecoration(
                      hintText: "Disc(%)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                    onChanged: (value)
                    {

                      disc=double.tryParse(value) ?? 0;
                       itemData.updateValues(pId,qty,disc);
         

                    },
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
                Confirmbutton(pId: itemData.pId,qty:itemData.qty,disc: itemData.disc),
                const SizedBox(width: 10),
                RemoveButton(k: key)
              ]),
        )
      ],
    ),
  );
}
// Widget updateitem()
// {

// }