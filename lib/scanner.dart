import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const color = const Color(0xff0000);

class ScanButton extends StatefulWidget {
  @override
  _ScanButtonState createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  String _scanBarcode = 'Unknown';
  String _itemName = 'Name';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print("Here");
      callEdamam(barcodeScanRes);
    });
  }

  Future<void> callEdamam(String barcode) async {
    var params = {
        "upc":barcode,
        "app_id":"077f1f88",
        "app_key":"1b3728b286915f7d5e9703c8de443e2a"
    };
    final uri = Uri.https("api.edamam.com", "/api/food-database/parser", params);
    final response = await http.get(uri);
    print("check1");

    var data = jsonDecode(response.body);
    
    var hints = data["hints"];
    var food = hints[0]["food"];
    var label = food["label"];
    setState(() {
      _itemName = label.toString();
    });

    
  }

  @override
  Widget build(BuildContext context)  {
   return Scaffold(
     appBar: AppBar(
        title: Text('Scanner'),
      ),
     body: Center(
       child: Column (children: <Widget>[
          FlatButton.icon(
            color: Colors.red,
            icon: Icon(Icons.add_a_photo),
            label: Text('Scanner'),
            onPressed: () => scanBarcodeNormal(),
          ),

          Text('Scan result : $_scanBarcode\n', style: TextStyle(fontSize: 20)),
          Text('API result : $_itemName\n', style: TextStyle(fontSize: 20))
       ]
       ),
      ) 
    );
  }
}