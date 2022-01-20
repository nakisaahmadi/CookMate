/*
 * Coders: Rayhan, Luis
 */
import 'package:cookmate/dialog.dart';
import 'package:cookmate/scanner.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:cookmate/cookbook.dart' as CB;
import 'dart:async';
import 'package:cookmate/util/database_helpers.dart' as DB;
import 'package:cookmate/searchResultPage.dart';

/*
  File: search.dart
  Functionality: This page handles the entire search functionality of the app.
  It allows users to enter items manually and select from a list of autocompleted
  ingredients within our database. It also implements the scanner class which allows
  the user to add ingredients via a barcode scanner. 
*/

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScanButtonState scanButt = new ScanButtonState();
  TextEditingController editingController = TextEditingController();

  // User Data
  String token;
  int userID;

  // Backend controller
  BackendRequest request;

  // Data containers
  var items = List<String>();
  var selectedIngredients = List<String>();
  List<String> copyOfIngredients = List<String>();
  List<String> diets = new List<String>();
  List<String> cuisines = new List<String>();
  List<DropdownMenuItem<String>> dropDownCuisines = [];
  Future<List<CB.Cuisine>> cuisinesList;

  // Queries for recipe search
  List<String> ingredientQuery;
  int maxCalories;
  String cuisineQuery;
  String dietQuery;

  // Recipe List results
  List<CB.Recipe> recipes = List<CB.Recipe>();
  Future<List<CB.Recipe>> recipesResult;

//**********Rayhan Code **********//
//********************************//

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    token = await LocalStorage.getAuthToken();
    userID = await LocalStorage.getUserID();
//    token = "03740945581ed4d2c3b25a62e7b9064cd62971a4";
//    userID = 2;
    request = BackendRequest(token, userID);
    _addAllIngredients();
    _getCuisines();
    _getIngredients();
  }

  _recipeSearch() async {
    recipesResult = request.recipeSearch(
        cuisine: cuisineQuery,
        maxCalories: maxCalories,
        ingredients: ingredientQuery);
  }

  _routeRecipePage(BuildContext context) async {
    _recipeSearch();
    if (recipesResult != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchResultPage(recipesResult)));
    }
    _clearQueries();
  }

  _clearQueries() {
    recipes.clear();
    if (ingredientQuery != null) ingredientQuery.clear();
    ingredientQuery = null;
    cuisineQuery = null;
  }

  _getCuisines() async {
    cuisinesList = request.getCuisineList();
    cuisinesList.then((currList){
      setState(() {
        cuisines.add("None");
        for(int i  = 0; i < currList.length; i++){
          cuisines.add(currList[i].name);
        }
      });
    });

  }

  _getDiets() async {
    request.getDietList().then((dietList) {
      for (int i = 0; i < dietList.length; i++) {
        diets.add(dietList[i].name);
      }
    });
  }

  _getIngredients() async {
    DB.DatabaseHelper helper = DB.DatabaseHelper.instance;
    helper.ingredients().then((list) {
      setState(() {
        for (int i = 0; i < list.length; i++) {
          copyOfIngredients.add(list[i].name);
        }
      });
    });
  }

  _addAllIngredients() async {
    //String token = await LocalStorage.getAuthToken();
    if (token != '-1') {
      //int userID= await LocalStorage.getUserID();
      // or ideally change backendRequest to not need userID
      DB.DatabaseHelper helper = DB.DatabaseHelper.instance;

      // gets ingredient list from server
      // adds them to locally if not exist
      await request.getIngredientList().then((ingList) {
        for (dynamic ing in ingList) {
          DB.Ingredient newIng = DB.Ingredient(name: ing.name, id: ing.id);
          helper.insertIngredient(newIng);
        }
      });
      // display all ingredients...
//      print(await helper.ingredients());// returns a list of all ingredients
    } else {
      print("User is not logged in.");
    }
  }

  // Setters
  _setCuisine(String cuisine) {
    if (cuisine != null) cuisineQuery = cuisine;
    if (cuisine == "None") cuisineQuery = null;
    print(cuisineQuery);
    print(cuisine);
  }

  _addIngredientQuery(String ingredient) {
    print(ingredient);
    bool same = false;
    if (ingredientQuery == null) ingredientQuery = new List<String>();
    for(int i = 0; i < ingredientQuery.length; i ++) {
      if (ingredientQuery[i] == ingredient) {
        same = true;
      }
    }
    if (ingredient != null && same == false) {
      ingredientQuery.add(ingredient.toString());
      print(ingredientQuery);
    }
  }

  _getIngredientBarCode(List<String> ingredients) {
    if (ingredientQuery == null) ingredientQuery = new List<String>();
    if (ingredientQuery != null) {
      ingredientQuery.addAll(ingredients);
    }
  }

  void generateDropdown(String query) {
    List<String> testList = List<String>();
    testList.addAll(copyOfIngredients);
    int counter = 0;
    if (query.isNotEmpty) {
      List<String> dropdownData = List<String>();
      testList.forEach((item) {
        if (item.contains(query) && counter < 10) {
          dropdownData.add(item);
          counter++;
        }
      });
      setState(() {
        items.clear();
        items.addAll(dropdownData);
      });
      return;
    } else {
      setState(() {
        items.clear();
      });
    }
  }

  String displayIngredients(List<String> ingredient) {

    if(ingredient == null) {
      return "No ingredients added yet!";
    }

    String display = "";
    for (int i = 0; i < ingredient.length; i++) {
      String token = ingredient[i];
      display += "$token";
      if (i != ingredient.length - 1) {
        display += ", ";
      }
    }
    return display;
  }

  Widget itemList () {

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ingredientQuery == null ? 0 : ingredientQuery.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 4.0),
            child: RawChip(
              selected: true,
              selectedColor: Color.fromRGBO(255, 0, 0, 0.4),
              showCheckmark: false,
              onPressed: () {
                setState(() {
                  ingredientQuery.removeAt(index);
                });
              },
              label: Text(
                ingredientQuery[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget cuisineButton() {

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton<String>(
        hint: Text("Cuisines"),
        onChanged: (value) {
          setState(() {
            _setCuisine(value);
          });
        },
        isExpanded: true,
        iconSize: 35,
        value: cuisineQuery,
        items: cuisines.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  _getBCList() async {
    List<String> bcList = await scanButt.scanBarcodeNormal();
    if(bcList.length == 100){

    }
    else if (bcList != null) {
      if (ingredientQuery == null) ingredientQuery = new List<String>();
      for (int i = 0; i < bcList.length; i++) {
        ingredientQuery.add(bcList[i]);
        print(bcList[i]);
      }
    }
    else if (bcList == null || bcList.length == 0){ 
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: NavBar(title: "Search", titleSize: 25, hasReturn: true, isSearch: true),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: copyOfIngredients.length > 0 ? TextField(
                onChanged: (value) {
                  setState(() {
                    generateDropdown(value);
                  });
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Input an Ingredient",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          setState(() {
                            _getBCList();
                          });
                        }),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5, color: CookmateStyle.iconGrey),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ) : CircularProgressIndicator(strokeWidth: 1),
            ),
            FutureBuilder(
                future: cuisinesList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading cuisines");
                    case ConnectionState.done:
                      return cuisineButton();
                    default:
                      return Center(child: Text("Error: Loading cuisines"));
                  }
                }),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return new Container(
                      child: new ListTile(
                        title: new Text(
                          '${items[index]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.add_circle,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          setState(() {
                            _addIngredientQuery('${items[index]}');
                          });
                          String display = displayIngredients(ingredientQuery);
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text("Selected Ingredients", textAlign: TextAlign.center),
                                content: Text("$display", style: TextStyle(fontWeight: FontWeight.w300)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ));
                          editingController.clear();
                        },
                      ),
                      decoration: new BoxDecoration(
                          border: new Border(bottom: new BorderSide(
                            width: 0.1
                          ))));
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ingredientQuery != null && ingredientQuery.isNotEmpty && ingredientQuery.length > 3 ? "Swipe right for more ingredients >" : "Tap to remove",
                style: TextStyle(
                  fontSize: 14,
                  color: CookmateStyle.iconGrey,
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
            itemList(),
            new Container(
              margin: new EdgeInsets.all(20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget> [
                      Container(
                        height: 45,
                        width: 100,
                        child: RaisedButton(
                          color: CookmateStyle.standardRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.list, color: Colors.white, size: 30),
                          elevation: 1,
                          onPressed: () {
                            String display = displayIngredients(ingredientQuery);
                            editingController.clear();
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text("Ingredients", textAlign: TextAlign.center),
                                  content: Text("$display", style: TextStyle(fontWeight: FontWeight.w300)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Full List",
                          style: TextStyle(
                            fontSize: 15,
                            color: CookmateStyle.textGrey
                          ),
                        ),
                      )
                    ]
                  ),
                  Column (
                    children: <Widget> [ 
                      Container(
                        height: 45,
                        width: 100,
                        child: RaisedButton(
                          color: CookmateStyle.standardRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.search, color: Colors.white, size: 30),
                          elevation: 1,
                          onPressed: () {
                            setState(() {
                              items.clear();
                            });
                            editingController.clear();
                            _routeRecipePage(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 15,
                            color: CookmateStyle.textGrey
                          ),
                        ),
                      )
                    ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}