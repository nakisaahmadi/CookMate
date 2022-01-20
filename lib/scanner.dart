import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cookmate/util/localStorage.dart' as LS;

/*
  File: scanner.dart
  Functionality: This file allows the user to open their camera and use it to
  scan an items barcode and recieve recipes for it. It searches our database for
  the UPC and if it is found it adds the ingredient to the ongoing search.
*/

class ScanButton extends StatefulWidget {
  @override
  ScanButtonState createState() => ScanButtonState();
}

class ScanButtonState extends State<ScanButton> {
  List<String> ingredientsForSearch;
  int userID;
  String token;
  BackendRequest be;

  Future<List<String>> scanBarcodeNormal() async {
    userID = await LS.LocalStorage.getUserID();
    token = await LS.LocalStorage.getAuthToken();
    be = new BackendRequest(token, userID);

    String barcodeScanRes;
    List<String> ingredients;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if(barcodeScanRes == null){
      return new List<String>(100);
    }
    //print("after opening barcode");
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return null;

    //Call the backend with the barcode to return the Bread Crumb list
    barcodeScanRes = barcodeScanRes.substring(1);

    List<String> breadCrumbs = await be.getBreadcrumbs(barcodeScanRes);

    //Check the breadcrumbs for usable ingredients
    ingredients = await getIngredients(breadCrumbs);
    return ingredients;
  }

  Future<List<String>> getIngredients(List<String> breadCrumbs) async {
    if(breadCrumbs == null || breadCrumbs.length == 0){
      return null;
    }
    int userID = await LS.LocalStorage.getUserID();
    String token = await LS.LocalStorage.getAuthToken();
    BackendRequest request = new BackendRequest(token, userID);
    
    //get the indredient list
    List<Ingredient> ingredients = await request.getIngredientList();
    List<String> matched = new List<String>();

    for (int i = 0; i < breadCrumbs.length; i++) {
      var curr = breadCrumbs[i];
      for (int j = 0; j < ingredients.length; j++) {
        if (ingredients[j].name == curr) {
          matched.add(ingredients[j].name);
        }
      }
      if (matched.length == 0) {
        for (int j = 0; j < ingredients.length; j++) {
          if (ingredients[j].name.contains(curr)) {
            matched.add(ingredients[j].name);
          }
        }
      }
    }
    return matched;
  }

  List<String> getList() {
    return this.ingredientsForSearch;
  }

  @override
  Widget build(BuildContext context) {
  
  }
}
