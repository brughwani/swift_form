import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/OrderformItem.dart';

TextEditingController item_name=TextEditingController();
TextEditingController price=TextEditingController();
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
      var url="http://10.0.2.2:3000/api/v1/items";
      var body={"name":item_name.text,"price":price.text};
      var headers={{}};

        setState(() {
          isPressed=true;
        });
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
   // var index=widgetlist.indexOf();


    return InkWell(
      onTap: ()
      {
       // print(itemindex);
       Item.removeitem(k);
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

Widget item()
{
  final key=UniqueKey();
  return Container(
    key:key,
    height:300,
    child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16,24,16,16),
            child: TextField(

              decoration: InputDecoration(
                  hintText: "Item Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
          ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left:16),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Quantity",
                          border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
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
                Flexible(
                  child: Padding(
                    padding:  EdgeInsets.only(right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Discount Rate",
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
                    Confirmbutton(),
                    SizedBox(width:10),
                    RemoveButton(k:key)
                  ]
              ),
            )
          ],

    ),
  );
}
