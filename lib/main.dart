import 'package:flutter/material.dart';
import 'package:shopping_app/presentations/features/sign_in/sign_in_page.dart';
import 'package:shopping_app/presentations/features/sign_up/sign_up_page.dart';

void main() {
  runApp(const MyApp());
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
      },
      initialRoute: "/sign-in",
    );
  }
}

