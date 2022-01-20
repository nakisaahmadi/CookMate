import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/database_helpers.dart' as DB;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
  File: shoppingListPage.dart
  Functionality: This file displays the shopping list page for the user. If a 
  user adds a recipe to the shopping list from the recipe page the ingredients 
  are added to our local database that is stored on the phone and this page
  grabs those ingredients and displays them. It displays the ingredient's name,
  quantity to purchase, and units. It allows the user to increment or decrement 
  the amount to purchase, remove an ingredient from the list, mark as purchased,
  and clear the entire shopping list.
*/

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  
  Future<List<DB.ShoppingList>> _slFuture;

  @override
  void initState() {
    _initializeSL();
    super.initState();
  }

  _initializeSL() {
    DB.DatabaseHelper db = DB.DatabaseHelper.instance;
    _slFuture = db.shoppingListItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: "Shopping List", titleSize: 20, isShoppingList: true),
      body: FutureBuilder(
        future: _slFuture,
        builder: (futureContext, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CookmateStyle.loadingIcon("Loading your shopping list...");
            case ConnectionState.done:
              return shoppingListView(snapshot.data);
            default:
              return Center(child: Text("error"));
          }
        },
      ),
    );
  }

  Widget shoppingListView(List<DB.ShoppingList> list) {

    if (list == null || list.length == 0) {
      return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Looks like your shopping list is empty!",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: CookmateStyle.textGrey),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.shopping_cart,
              color: CookmateStyle.iconGrey,
              size: 40,
            ),
          )
        ],
      ));
    }

    List<Widget> items = List<Widget>();
    String quantityDisplay;
    int purchasedItems = 0;

    for (DB.ShoppingList item in list) {
      quantityDisplay = _formatAmount(item.quantity);
      if (item.measurement != null) {
        quantityDisplay += " ${item.measurement}";
      }
      if (item.purchased) {
        purchasedItems++;
      }
      Widget shoppingItem = Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 15)),
          Checkbox(
            value: item.purchased,
            activeColor: CookmateStyle.standardRed,
            checkColor: Colors.white,
            onChanged: (newValue) {
              setState(() {
                item.purchased = newValue;
                _updateShoppingItem(item);
              });
            },
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          Container(
            width: 140,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      iconSize: 12,
                      color: item.purchased == true
                          ? Color.fromRGBO(230, 230, 230, 1)
                          : CookmateStyle.iconGrey,
                      disabledColor: Color.fromRGBO(230, 230, 230, 1),
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: item.quantity == 0
                          ? null
                          : () {
                              setState(() {
                                item.quantity--;
                                _updateShoppingItem(item);
                              });
                            },
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 80,
                    height: 20,
                    child: Center(
                      child: Text(
                        quantityDisplay,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: item.purchased == true
                            ? TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: CookmateStyle.standardRed,
                                decoration: TextDecoration.lineThrough)
                            : TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: CookmateStyle.textGrey,
                              ),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      iconSize: 12,
                      color: item.purchased == true
                          ? Color.fromRGBO(230, 230, 230, 1)
                          : CookmateStyle.iconGrey,
                      disabledColor: Color.fromRGBO(230, 230, 230, 1),
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: item.purchased == true
                          ? null
                          : () {
                              setState(() {
                                item.quantity++;
                                _updateShoppingItem(item);
                              });
                            },
                    ),
                  ),
                ]),
          ),
          Spacer(),
          SizedBox(
            width: 120,
            height: 40,
            child: Center(
              child: Text(
                item.ingredient,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: item.purchased == true
                    ? TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: CookmateStyle.standardRed,
                        decoration: TextDecoration.lineThrough)
                    : TextStyle(
                        fontSize: 17,
                        color: CookmateStyle.textGrey,
                      ),
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            width: ScreenUtil.getInstance().setWidth(30),
            child: IconButton(
                iconSize: 10,
                icon: Icon(Icons.clear),
                color: Color.fromRGBO(230, 100, 100, 1),
                onPressed: () {
                  setState(() {
                    _removeShoppingItem(item);
                    _initializeSL();
                  });
                },
            ),
          ),
          Spacer(flex: 4)
        ],
      );
      items.add(shoppingItem);
      items.add(Divider());
    }

    return Column(
      children: <Widget>[
        Container(
          height: 30,
          //color: Color.fromRGBO(240, 240, 240, 1),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 30)),
                Text(
                  "$purchasedItems/${list.length}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: CookmateStyle.iconGrey),
                ),
                Spacer(),
                FlatButton(
                  child: Text(
                    "CLEAR",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: CookmateStyle.iconGrey),
                  ),
                  onPressed: () {
                    setState(() {
                      _clearShoppingList();
                      _initializeSL();
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(right: 20)),
              ],
            ),
          ),
        ),
        Divider(),
        Flexible(child: ListView(children: items))
      ],
    );
  }

  _clearShoppingList() {
    DB.DatabaseHelper helper = DB.DatabaseHelper.instance;
    helper.clearShoppingList(); // removes all local shopping list items
  }

  _removeShoppingItem(DB.ShoppingList sl) {
    DB.DatabaseHelper helper = DB.DatabaseHelper.instance;
    helper.deleteShoppingListItem(
        sl.ingredient); // removes all local shopping list items
  }

  _updateShoppingItem(DB.ShoppingList sl) {
    DB.DatabaseHelper helper = DB.DatabaseHelper.instance;
    helper.updateShoppingListItem(sl);
  }

  String _formatAmount(double amount) {
    if (amount == 0.25) {
      return "1/4";
    } else if (amount == 0.5) {
      return "1/2";
    } else if (amount == 0.3333333333333333){
      return "1/3";
    } else if (amount == 0.125) {
      return "1/8";
    } else if (amount < 0.125) {
      return "pinches";
    } else
      return amount.round().toString();
  }
}
