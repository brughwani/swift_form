import 'package:carousel_slider/carousel_slider.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
//import 'package:swift_form/model/Salesman.dart';
import 'package:swift_form/view/Swiftform.dart';
//import 'package:dio/dio.dart' as dio;
//import 'package:dio_http_cache/dio_http_cache.dart';
class SwiftFormName extends StatefulWidget {
  SwiftFormName({Key? key,required this.authtoken}) : super(key: key);

  String authtoken;

  @override
  State<SwiftFormName> createState() => _SwiftFormNameState();
}

class _SwiftFormNameState extends State<SwiftFormName> {
  final name=TextEditingController();
  List<String> urls=['assets/Wavy_Bus-31_Single-04.png','assets/6736639 (1).png','assets/20943429 (1).png'];


  Future<void> createSalesman(String name)
  async {
    var url="http://10.0.2.2:3000/users/update_details";
    var body={"name":name};
    final Map<String, String>? headers = {
      'Authorization': widget.authtoken
      // Add any other required headers
    };
    //print(body);
    try {
      var response = await put(Uri.parse(url),body: body,headers: headers);
      if(response.statusCode==200)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SwiftForm()));
          Fluttertoast.showToast(
              msg: "Account created successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 12
          );

        }
      else
        {
          print("status code:${response.statusCode}");
          Fluttertoast.showToast(
              msg: "Account creation failed with status code:${response.statusCode}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 12
          );
        }
    }
    catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error ${e}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 12);
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        Image(
        image: AssetImage("assets/Frame 43.png")),
      Text("Create Orders in a flash",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
      CarouselSlider(options:CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 9,
      ),items: urls.map((String path){
        return Image(
            alignment: Alignment.center,
            width:MediaQuery.of(context).size.width,
            height: 363,    image: AssetImage(path)) ;
      }).toList()),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
        child: TextField(

          controller: name,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your Name',
          ),

        ),
      ),
              InkWell(
                onTap: ()
                {
                  createSalesman(name.text);
                },
                child: Container(
                  height: 48,
                  width:328,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("Next"),
                ),
              ),
        ])
      ),
    );
  }
}
