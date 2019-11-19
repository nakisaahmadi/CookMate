import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'dialog.dart';


class ScanButton extends StatefulWidget {
  @override
  ScanButtonState createState() => ScanButtonState();

  List<String> getIngredients(){
    
  }
}

class ScanButtonState extends State<ScanButton> {
  String _scanBarcode = 'Unknown';
  String _itemName = 'Name';
  List<String> test;

  Future<List<String>> scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    List<String> ingredients;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return null;

    //Call the backend with the barcode to return the Bread Crumb list
    List<String> breadCrumbs = await BackendRequest.barcode("089836187635", "42e96d88b6684215c9e260273b5e56b0522de18e");

    //If the backend does not return us anything this displays a popup
    if(breadCrumbs == null){
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
           title: "Uh Oh",
           description:
            "Barcode not found in our database, please try entering the item manually",
           buttonText: "Okay",
          ),
        );
    }
    else{
     //Check the breadcrumbs for usable ingredients
     test = await getIngredients(breadCrumbs, "42e96d88b6684215c9e260273b5e56b0522de18e");

     setState(() {
       test = ingredients;
     });
    }
  }

  Future<List<String>> getIngredients(List<String> breadCrumbs, String authToken) async {
      //get the indredient list
      List<Ingredient> ingredients = await BackendRequest.ingredientList(authToken);
      List<String> matched = new List<String>();
      
      for(int i =0; i < breadCrumbs.length; i++){
        var curr = breadCrumbs[i];
        for(int j = 0; j < ingredients.length; j++){
          if(ingredients[j].name.contains(curr)){
            matched.add(ingredients[j].name);
          }
        }
      }
      return matched;
  }

  // @override
  // Widget build(BuildContext context)  {
  //  return Scaffold(
  //    appBar: AppBar(
  //       title: Text('Scanner'),
  //     ),
  //    body: Center(
  //      child: Column (children: <Widget>[
  //         FlatButton.icon(
  //           color: Colors.red,
  //           icon: Icon(Icons.add_a_photo),
  //           label: Text('Scanner'),
  //           onPressed: () {
  //             scanBarcodeNormal(context);
  //           },
  //         ),

  //         Text('Scan result : $_scanBarcode\n', style: TextStyle(fontSize: 20)),
  //         Text('API result : $_itemName\n', style: TextStyle(fontSize: 20))
  //      ]
  //      ),
  //     ) 
  //   );
  // }

  List<String> getList(){
    return this.test;
  }

  @override
  Widget build(BuildContext context)  {
    return IconButton(
      icon: Icon(Icons.camera),
      onPressed: (){
        scanBarcodeNormal(context);
      }
    );
  }
}