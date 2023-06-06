import 'package:flutter/material.dart';
import 'package:swift_form/controller/OrderformItem.dart';
import 'package:provider/provider.dart';
class Confirmlist extends StatefulWidget {
  const Confirmlist({Key? key}) : super(key: key);

  @override
  State<Confirmlist> createState() => _ConfirmlistState();
}

class _ConfirmlistState extends State<Confirmlist> {
  Future<void> CreateOrderForm()
  async {
    var url="http://10.0.2.2:3000/api/v1/order_forms";
    var body={
    };
  }


  bool isPressed=false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {

        setState(() {
          isPressed=true;
        });
      },
      child: Container(
        height: 48,
        width:328,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isPressed ? Colors.grey: Colors.amberAccent,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text("Confirm Order"),
      ),
    );
  }
}


class OrderForm extends StatefulWidget {
  OrderForm({Key? key}) : super(key: key);

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderFormItem>(
        builder: (context, state, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Image(image: AssetImage("assets/Frame 44.png"),
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(94, 12, 95, 57),
                                child: Text("CREATE ORDER LIST", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),),
                              ),
                            ])),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),

                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Customer Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),

                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Village",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),

                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Customer Discount",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    ),
                    ...state.widgetlist,
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: InkWell(
                        onTap: () {
                          state.addwidget();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all()),
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline),
                              Text("Add Item")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),

                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Note/Scheme",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    ),

                    Confirmlist()
                  ],

                ),
              )

          );
        });
  }
}
