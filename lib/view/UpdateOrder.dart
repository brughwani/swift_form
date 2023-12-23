import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../model/itemwidget.dart';
//import 'package:searchfield/searchfield.dart';
import '../model/product.dart';
import 'package:http/http.dart';
TextEditingController village = TextEditingController();
TextEditingController customer = TextEditingController();

class UpdateOrder extends StatelessWidget {
  const UpdateOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 48,
        width: 328,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:  Colors.amberAccent,
            borderRadius: BorderRadius.circular(10)),
        child: const Text("Update Order"),
      ),
    );
  }
}

class UpdateOrderForm extends StatefulWidget {
  UpdateOrderForm({super.key,required this.id,required this.auth});
  String auth;
  int id;

  @override
  State<UpdateOrderForm> createState() => _UpdateOrderFormState();
}

class _UpdateOrderFormState extends State<UpdateOrderForm> {
  void initState()
  {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false)
        .fetchproducts(widget.auth);
  }



  Future<Map<String, dynamic>> fetchOrderDetails() async {
    var url = "http://localhost:3000/api/v1/order_forms/${widget.id}";
    final Map<String, String>? headers = {
      'Authorization': widget.auth,
      // Add any other required headers,
    };
    var response = await get(Uri.parse(url), headers: headers);
    var data=jsonDecode(response.body);
   
    if(data is Map<String, dynamic>) {
      print(data);

    }
    
    //print(_data);
    return data;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Image(
              image: AssetImage("assets/Frame 44.png"),
              width: 176,
              height: 36,
            ),
          ),
          body:FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            //print(snapshot.data!);
            customer.text = snapshot.data!['customer']['name'];
            village.text=snapshot.data!['customer']['address']; 
       return   SingleChildScrollView(
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
                          "UPDATE ORDER FORM",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),

                    ])),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child:TextField(
                    enabled: false,
                    controller: customer,
                    decoration: InputDecoration(
                        hintText: "Customer name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    enabled: false,
                    controller: village,
                    decoration: InputDecoration(
                        hintText: "Village",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                item(context: context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: InkWell(
                    onTap: () {
                      //state.addwidget(context);

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
                UpdateOrder()
              ]   
    
    )
          
          );
          }
          }
          
    
    ));
  
  }

}
