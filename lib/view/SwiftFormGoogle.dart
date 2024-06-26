import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift_form/config/config.dart';
//import 'package:swift_form/model/Salesman.dart';
import 'package:swift_form/view/SwiftFormLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart';

class SwiftformGoogleLogin extends StatefulWidget {
  SwiftformGoogleLogin({
    Key? key,
  }) : super(key: key);

  @override
  State<SwiftformGoogleLogin> createState() => _SwiftformGoogleLoginState();
}

class _SwiftformGoogleLoginState extends State<SwiftformGoogleLogin> {
  List<String> urls = [
    'assets/Wavy_Bus-31_Single-04.png',
    'assets/6736639 (1).png',
    'assets/20943429 (1).png'
  ];

  String authtoken = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> saveData(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value!);
  }

  Future<bool> hasDataCollected(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('email'));
    return prefs.containsKey(key);
  }

  Future<int?> firebasesignin(var token) async {
    // var url = "http://10.0.2.2:3000/auth/firebase";
    
    var url2 = "${Config.getBaseUrl}/auth/firebase";
    //Dio dio = Dio();
    var body = jsonEncode({"id_token": "$token"});
    final Map<String, String>? headers = {
      //'Authorization': widget.authtoken,
      // Add any other required headers,
      'Content-Type': 'application/json'
    };
    //print(token);
    try {
      var response = await post(Uri.parse(url2),headers: headers, body: body);
//print(response.statusCode);
print(response.body);

//print(authtoken);
      print(1);
      if (response.statusCode == 200) {
        Map<String, dynamic> decoded = jsonDecode(response.body);

//authtoken=decoded['token']['Authorization'];
        setState(() {
          authtoken = decoded['token']['Authorization'];
        });
        Fluttertoast.showToast(
            msg: "User created successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 12);

        return response.statusCode;
      } else {
        Fluttertoast.showToast(
            msg:
                "User creation failed with status code :${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 12);

        return response.statusCode;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: " Error code :${e}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 12);

      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
   //   await _googleSignIn.signInSilently(reAuthenticate: true);
      return userCredential;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: hasDataCollected('email'),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data == true &&
              authtoken.isNotEmpty) {
            // print(authtoken);
            return SwiftFormLogin(authtoken: authtoken);
          } else {
            return Scaffold(
              body: SafeArea(
                  child: Column(
                children: [
                  Image(image: AssetImage("assets/Frame 43.png")),
                  Text("Create Orders in a flash",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                      ),
                      items: urls.map((String path) {
                        return Image(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 363,
                            image: AssetImage(path));
                      }).toList()),
                  InkWell(
                    onTap: () async {
                      final UserCredential? userCredential =
                          await signInWithGoogle();
                      final user = FirebaseAuth.instance.currentUser;

                      //print(user.email);
                      final idToken = await user?.getIdToken();

                      int? status = await firebasesignin(idToken);

                      if (userCredential != null && status == 200) {
                        await saveData('email', user!.email);
                       // print(authtoken);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SwiftFormLogin(authtoken: authtoken)));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Google Signin failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.grey,
                            textColor: Colors.black,
                            fontSize: 12);
                      }
                    },
                    child: Container(
                      height: 48,
                      width: 328,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.amber,
                        ),
                      ),
                      child: Row(
                        children: [
                          ImageIcon(size: 22, AssetImage("assets/2991148.png")),
                          Text("Login with Google")
                        ],
                      ),
                    ),
                  )
                ],
              )),
            );
          }
        });
  }
}
