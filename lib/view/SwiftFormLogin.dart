import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
//import 'package:swift_form/model/Salesman.dart';
import 'package:swift_form/config/config.dart';

import 'package:http/http.dart';
//import 'package:swift_form/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SwiftFormName.dart';

//import 'package:swift_form/model/Phoneauth.dart';
//import 'package:swift_form/view/SwiftFormOTP.dart';

class SwiftFormLogin extends StatefulWidget {
  SwiftFormLogin({Key? key, required this.authtoken}) : super(key: key);

   String authtoken;



  @override
  State<SwiftFormLogin> createState() => _SwiftFormLoginState();
}

class _SwiftFormLoginState extends State<SwiftFormLogin> {
  final _phoneController = TextEditingController();
  bool _isPressed = false;
  List<String> urls = [
    'assets/Wavy_Bus-31_Single-04.png',
    'assets/6736639 (1).png',
    'assets/20943429 (1).png'
  ];

  // Salesman s=new Salesman(email: "", phone: "", name:"");

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<bool> hasDataCollected(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('phone'));
    return prefs.containsKey(key);
  }


  Future<void> updatephone(String phone) async {
    var url = "http://10.0.2.2:3000/users/update_details";
    var url2 = "${Config.getBaseUrl}/users/update_details";
    var body = {"phone_number": "${phone}"};
    //print(widget.authtoken);
    final Map<String, String>? headers = {
      'Authorization': widget.authtoken
      // Add any other required headers
    };

    try {
      var response = await put(Uri.parse(url2), body: body, headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);


        Fluttertoast.showToast(msg: "Phone number added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 12);
      }
      else {
        print(response.body);
        Fluttertoast.showToast(
            msg: "Phone number addition failed with status code :${response
                .statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 12);
      }
    }
    catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Phone number addition failed with status code :${e}",
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
    //var phonelogin=Provider.of<PhoneProvider>(context);

    return FutureBuilder(
        future: hasDataCollected('phone'),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return SwiftFormName(authtoken: widget.authtoken);
          } else {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body:
                SafeArea(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                              image: AssetImage("assets/Frame 43.png")),
                          Text("Create Orders in a flash", style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                          CarouselSlider(options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                          ), items: urls.map((String path) {
                            return Image(
                                alignment: Alignment.center,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 363, image: AssetImage(path));
                          }).toList()),
                          Text("Continue with your mobile number",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: TextField(
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your phone number',
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 94),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPressed = true;
                                });
                              },
                              child: InkWell(
                                onTap: () async {
                                  // phonelogin.sendOtp("+91"+_phoneController.text);
                                  saveData('phone', _phoneController.text);
                                  updatephone(_phoneController.text);
                                  //widget.s.phone=_phoneController.text;
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          SwiftFormName(
                                            authtoken: widget.authtoken,)),);
                                },
                                child: Container(
                                  height: 48,
                                  width: 328,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: _isPressed ? Colors.grey : Colors
                                          .amber,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text("Next"),
                                ),
                              ),
                            ),
                          ),

                        ]
                    )
                )
            );
          }
        });
  }
}
