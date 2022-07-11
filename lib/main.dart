import 'package:flutter/material.dart';
import 'package:shopping_app/data/datasources/local/cache/app_cache.dart';
import 'package:shopping_app/presentations/features/profile/profile_page.dart';
import 'package:shopping_app/presentations/features/cart/cart_page.dart';
import 'package:shopping_app/presentations/features/home/home_page.dart';
import 'package:shopping_app/presentations/features/sign_in/sign_in_page.dart';
import 'package:shopping_app/presentations/features/sign_up/sign_up_page.dart';
import 'package:shopping_app/presentations/features/splash/splash_page.dart';

Future<void> main() async {
  runApp(const MyApp());
  await AppCache.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        "/cart": (context) => CartPage(),
        "/": (context) => SplashPage(),
      },
      initialRoute: "/",
    );
  }
}

