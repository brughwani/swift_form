import 'dart:convert';
import 'dart:io';
import 'Addcustomer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swift_form/model/customer.dart';
import 'package:swift_form/view/Orderform.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:swift_form/view/ViewOrderform.dart';
import 'UpdateOrder.dart';
import 'package:swift_form/config/config.dart';
class SwiftForm extends StatefulWidget {
   SwiftForm({Key? key,required this.authtoken,required this.Name,required this.Phone,required this.email}) : super(key: key);

   String authtoken;
   String Name;
   String Phone;
   String email;

  @override
  State<SwiftForm> createState() => _SwiftFormState();
}

class _SwiftFormState extends State<SwiftForm> {
  List<int> customerids = [];

  List<Map<String, dynamic>> customers = [];
  List<int> orders = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> uploaditemdata(List<Map<String, dynamic>> itemdata) async {
    var url = "http://10.0.2.2:3000/api/v1/items/bulk_create";
    var url2="${Config.getBaseUrl}/api/v1/items/bulk_create";
    final Map<String, String>? headers = {
      'Authorization': widget.authtoken,
      // Add any other required headers,
      'Content-Type': 'application/json'
    };
    String body = jsonEncode({"items": itemdata});

    var response = await http.post(
        Uri.parse(url2), headers: headers, body: body);
    if (response.statusCode == 200) {
      print("Success");
      Fluttertoast.showToast(
          msg: "Upload Sucessful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 12
      );
    }
    else {
      print(response.body);
      Fluttertoast.showToast(
          msg: "Upload failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 12
      );
    }
  }

  Future<void> uploadcustomerdata(
      List<Map<String, dynamic>> customerdata) async {
    var url = "http://10.0.2.2:3000/api/v1/customers/bulk_create";
    var url2="${Config.getBaseUrl}/api/v1/customers/bulk_create";
    final Map<String, String>? headers = {
      'Authorization': widget.authtoken,
      // Add any other required headers,
      'Content-Type': 'application/json'
    };

    String body = jsonEncode({"customers": customerdata});


    var response = await http.post(
        Uri.parse(url2), headers: headers, body: body);
    if (response.statusCode == 200) {
      print("Success");
      Fluttertoast.showToast(
          msg: "Upload Sucessful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 12
      );
    }
    else {
      print(response.body);
      Fluttertoast.showToast(
          msg: "Upload failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 12
      );
    }
  }

  void _openitemFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls']);
    if (result != null) {
      String filePath = result.files.single.path!;
      _uploaditemFile(filePath);
    }
  }

  void _opencustomerPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls']);
    if (result != null) {
      String filePath = result.files.single.path!;
      _uploadcustomerFile(filePath);
    }
  }

  void _uploaditemFile(String filePath) async {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    List<Map<String, dynamic>> item = [];

    for (var table in excel.tables.keys) {
      var rows = excel.tables[table]!.rows;
      //print(rows);

      // Skip header row if needed
      var startIndex = 1;
      // Process each row
      for (var i = startIndex; i < rows.length; i++) {
        var row = rows[i];

        //print(row[1]?.value.toString());
        // Access the first two columns by their indices

        String? name = row[0]!.value.toString();
        //String? address = row[1]!.value.toString();
        //print(row[1]!.value);

        double price = double.parse(row[1]!.value.toString());

        Map<String, dynamic> pricelist = {"name": name, "price": price};
        item.add(pricelist);
      }
      uploaditemdata(item);
    }
  }

  Future<void> deleteorderform(int id) async {
    var url2 = "http://127.0.0.1:3000/api/v1/order_forms/" + id.toString();
    var url3 = "${Config.getBaseUrl}/api/v1/order_forms/" + id.toString();
    final Map<String, String>? headers = {
      'Authorization': widget.authtoken,
      // Add any other required headers,
    };
    var response = await http.delete(Uri.parse(url3), headers: headers);

//var data=jsonDecode(response.body);
    print(response.body);
  }

  Future<void> fetchorderforms() async {
    var url2 = '${Config.getBaseUrl}/api/v1/order_forms';
    final Map<String, String>? headers = {
      'Authorization': widget.authtoken,
      // Add any other required headers,
    };
    var response = await http.get(Uri.parse(url2), headers: headers);
    var data = jsonDecode(response.body);
    //print(data);

    customers.clear();
    orders.clear();

    for (var i in data) {

      customers.add(i['customer']);
      //print(i['order_form_id']);
      orders.add(i['id']);
    }
//print(customers);
//print(orders);
// print(customerids);

  }
void showFormDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add customer'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Village'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter village';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {

                _formKey.currentState!.save();
                // Now _name and _address hold the user input

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
  void _uploadcustomerFile(String filePath) async {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    List<Map<String, dynamic>> c = [];

    for (var table in excel.tables.keys) {
      var rows = excel.tables[table]!.rows;
      //print(rows);

      // Skip header row if needed
      var startIndex = 1;
      // Process each row
      for (var i = startIndex; i < rows.length; i++) {
        var row = rows[i];
        //print(row[1]?.value.toString());
        // Access the first two columns by their indices

        String? name = row[0]!.value.toString();
        String? address = row[1]!.value.toString();
        double discount = row[2]?.value;
        Map<String, dynamic> customer = {
          "name": name,
          "address": address,
          "discount": discount
        };
        c.add(customer);
      }
      uploadcustomerdata(c);
    }
  }


  @override
  Widget build(BuildContext context) {
//initState();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          title: Image(image: AssetImage("assets/Frame 44.png"),
            width: 172,
            height: 24,
            alignment: Alignment.topLeft,
          ),
          actions: [
            IconButton(onPressed: () {

              setState(() {

              });
              fetchorderforms();
            }, icon: Icon(Icons.refresh)),
            InkWell(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: CircleAvatar(child: Text(widget.Name),))
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: [Text(widget.Name),
                    Text(widget.Phone),
                    Text(widget.email)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
              ),
              ListTile(
                leading: Icon(Icons.upload),
                title: Text('Upload price list'),
                onTap: () {
                  _openitemFilePicker();
                  // Handle option 1 selection
                },
              ),
              ListTile(
                leading: Icon(Icons.upload),
                title: Text('Upload list of customers'),
                onTap: () {
                  // Handle option 2 selection
                  _opencustomerPicker();
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text("Add customer"),
                onTap: ()
                {
                 showFormDialog(context);
                },
              )
              // Add more ListTiles or custom widgets as needed
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: fetchorderforms(),
                    builder: (context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the future is executing, show a loading indicator
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // If there's an error, display an error message
                        return Text('Error: ${snapshot.error}');
                      } else if (orders.isEmpty) {
                        return
                          Column(
                              children: [
                                Text("Order Forms", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),),

                                Image(image: AssetImage(
                                    "assets/20943753 2 (1).png")),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            OrderForm(
                                                authtoken: widget.authtoken)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 94, horizontal: 12),
                                    child: Container(
                                      width: 328,
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.amber,),
                                      child: Text("Create Order Form"),
                                    ),
                                  ),
                                ),

                              ]);
                      }
                      else {
                        return Column(
                            children: [
                              Text("Order Forms", style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          OrderForm(
                                              authtoken: widget.authtoken)));
                                },
                                child: Container(
                                  width: 328,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber,),
                                  child: Text("Create Order Form"),
                                ),
                              ),

                              ListView.builder(itemCount: customers.length,
                              reverse: true,
                                  scrollDirection: Axis.vertical,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ListTile(title: Text(
                                        customers[index]['name']), subtitle: Text(
                                      customers[index]['address'],
                                    ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateOrderForm(id:orders[index],auth: widget.authtoken)));
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete_forever),
                                            onPressed: () async {
                                              print(orders);
                                              await deleteorderform(orders[index]);
                                              await fetchorderforms();
                                              setState(() {
                                                //orders.removeAt(index);

                                              });

                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => ViewOrderform(

                                              id: orders[index],
                                              auth: widget.authtoken,
                                            name:widget.Name,
                                          phone:widget.Phone),
                                        ));
                                      },
                                    );
                                  }
                              ),

                            ]

                        );
                      }
                    }
                )
              ]),
        )

    );
  }
}