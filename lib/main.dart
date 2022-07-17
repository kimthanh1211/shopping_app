import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/datasources/local/cache/app_cache.dart';
import 'package:shopping_app/presentations/features/order_history/order_history_page.dart';
import 'package:shopping_app/presentations/features/product_detail/product_detail_page.dart';
import 'package:shopping_app/presentations/features/profile/profile_page.dart';
import 'package:shopping_app/presentations/features/cart/cart_page.dart';
import 'package:shopping_app/presentations/features/home/home_page.dart';
import 'package:shopping_app/presentations/features/sign_in/sign_in_page.dart';
import 'package:shopping_app/presentations/features/sign_up/sign_up_page.dart';
import 'package:shopping_app/presentations/features/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await AppCache.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _firebaseApp =Firebase.initializeApp();
    // Future<void> initializeDefault() async {
    //   FirebaseApp app = await Firebase.initializeApp();
    //   print('Initialized default app $app');
    // }

    return FutureBuilder(
      future: _firebaseApp,
      builder: (context,snapshot){
        if(snapshot.hasError){
          print("Error" + snapshot.error.toString());
          return Text("Error Init Firebase ${snapshot.error.toString()}" , textDirection: TextDirection.ltr);
        }
        else if(snapshot.hasData){
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: "QuickSand",
              primarySwatch: Colors.blue,
            ),
            routes: {
              "/sign-in": (context) => SignInPage(),
              "/sign-up": (context) => SignUpPage(),
              "/profile": (context) => ProfilePage(),
              "/home": (context) => HomePage(),
              "/product-detail": (context) => ProductDetailPage(),
              "/cart": (context) => CartPage(),
              "/order-history": (context) => OrderHistoryPage(),
              "/": (context) => SplashPage(),
            },
            initialRoute: "/",
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


  }
}

