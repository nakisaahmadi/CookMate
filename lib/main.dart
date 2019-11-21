import 'package:cookmate/cookbook.dart';
import 'package:cookmate/homePage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';

void main() {

  BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2);
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