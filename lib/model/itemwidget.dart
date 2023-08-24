import 'dart:ffi';
//import 'dart:js_interop';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'product.dart';
import '../controller/OrderformItem.dart';
import 'order.dart';
import 'package:swift_form/view/Orderform.dart';
import 'dart:convert';
class Confirmbutton extends StatefulWidget {
  const Confirmbutton({Key? key}) : super(key: key);

  @override
  State<Confirmbutton> createState() => _ConfirmbuttonState();
}

class _ConfirmbuttonState extends State<Confirmbutton> {
  bool isPressed=false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {

      },
      child: Container(
        height: 48,
        width:164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isPressed ? Colors.grey: Colors.amber,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text("Confirm Item"),
      ),
    );
  }
}

class RemoveButton extends StatelessWidget {

  const RemoveButton({required this.k}) : super(key: k);

  final Key k;

  @override
  Widget build(BuildContext context) {
   var Item=Provider.of<OrderFormItem>(context);



    return InkWell(
      onTap: ()
      {
       // print(itemindex);
       Item.removeitem(k);

       //productorder.rem
       //productorder.remove(value.);



      //  Provider.of<OrderFormItem>(context,listen: false).removeitem(index);

      },
      child: Container(
        height: 48,
        width:164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text("Remove Item"),
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
  String dropdownvalue="R";
  @override
  Widget build(BuildContext context) {
    return Container(
      width:328,
      height:54,
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(10),
        value: dropdownvalue,
        items:["R","B"].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value:value,child:Text(value) );

        }).toList(),
        hint: Text("R/B"),  onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
      ),
    );
  }
}

Widget item( {required BuildContext context})
{

  String p_id="";
  String qty="";
  List<Product> products=Provider.of<ProductProvider>(context,listen: false).products;



  TextEditingController price=TextEditingController();
  //TextEditingController q=TextEditingController();
  final key=UniqueKey();
  return Container(
    key:key,
    height:300,
    child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16,24,16,16),
              child:SearchField<Product>(suggestions:products.map((e)=> SearchFieldListItem<Product>(
      e.name,item:e,child:ListTile(title:Text(e.name),trailing:Text(e.price.toString())))).toList(),

searchInputDecoration:InputDecoration(
hintText: "Item name",
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10)
)
),
onSuggestionTap: (e){
                
price.text="₹"+e.item!.price.toString();
p_id=e.item!.id;

//print(p_id);
},)
          ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left:16),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Quantity",
                          border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      onChanged: (value)
                      {
                        qty=value;
                        //productorderlist.add({productid:OrderItem(itemId: double.parse(p_id), quantity: double.parse(qty))});
                        productorder.add(OrderItem(itemId: double.parse(p_id), quantity: double.parse(qty)));
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: price,
                      decoration: InputDecoration(
                          hintText: "Price",
                          border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Billtype(),
            Expanded(
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    // Confirmbutton(),
                    // SizedBox(width:10),
                    RemoveButton(k:key)
                  ]
              ),
            )
          ],

    ),
  );
}
