import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swift_form/controller/OrderformItem.dart';
import 'package:swift_form/model/customer.dart';
import 'package:swift_form/model/itemdata.dart';
//import 'package:swift_form/model/order.dart';
import 'controller/Orderitem.dart';
import 'package:swift_form/model/product.dart';
//import 'package:swift_form/model/Salesman.dart';
//import 'package:swift_form/model/Phoneauth.dart';
//import 'view/SwiftFormLogin.dart';
import 'package:provider/provider.dart';
import 'view/SwiftFormGoogle.dart';
// import 'config/config_prod.dart' as prod;
// import 'config/config_dev.dart' as dev;
// import 'config/config.dart';
Future<void> main() async {

  
  WidgetsFlutterBinding.ensureInitialized();
  //final  s=Salesman(email: "", phone: "", name:"");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
 

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<OrderFormItem>(create:(context) =>  OrderFormItem(),),
    ChangeNotifierProvider<CustomerProvider>(create:(context) => CustomerProvider()),
    ChangeNotifierProvider<ProductProvider>( create:(context) => ProductProvider()),
    ChangeNotifierProvider(create: (context)=>OrderItemProvider()),
    ChangeNotifierProvider(create: ((context) => ItemData())),
    ChangeNotifierProvider(create: (context) => BillTypeProvider()),
    
    ],


      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.amber,
        ),
        home:
    SwiftformGoogleLogin(),
      ),
    );
  }
}

