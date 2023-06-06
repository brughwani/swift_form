import 'package:flutter/material.dart';
import 'package:swift_form/view/Orderform.dart';
class SwiftForm extends StatelessWidget {
  const SwiftForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Image(image:AssetImage("assets/Frame 44.png"),
          width: 172,
          height: 24,
          alignment: Alignment.topLeft,
        ),
        actions: [CircleAvatar()],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Order Forms",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          Image(image: AssetImage("assets/20943753 2 (1).png")),
          InkWell(
            onTap:()
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderForm()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 94,horizontal: 12),
              child: Container(
                width: 328,
                height:48,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),color: Colors.amber,),
                child: Text("Create Order Form"),
              ),
            ),
          )

        ],

      ),
    );
  }
}