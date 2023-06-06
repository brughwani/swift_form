import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swift_form/controller/OrderformItem.dart';
//import 'package:swift_form/model/Salesman.dart';
//import 'package:swift_form/model/Phoneauth.dart';
import 'view/SwiftFormLogin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/SwiftFormGoogle.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final  s=Salesman(email: "", phone: "", name:"");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //final Salesman s;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (_) => OrderFormItem(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.amber,
        ),
        home:  SwiftformGoogleLogin(),
      ),
    );
  }
}

