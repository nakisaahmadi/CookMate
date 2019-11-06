import 'package:cookmate/homePage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';

void main() {
  BackendRequest.login("testuser", "testpassword");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}