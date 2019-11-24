import 'package:flutter/material.dart';

import './util/database_helpers.dart';
import './util/localStorage.dart';
import './util/backendRequest.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local DB Example'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Login User'),
                  onPressed: () {
                    _loginUser();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Remove Token'),
                  onPressed: () {
                    _removeToken();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Add Allergen'),
                  onPressed: () {
                    _addAllergen();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Get Allergens'),
                  onPressed: () {
                    _getAllergens();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Remove Allergen'),
                  onPressed: () {
                    _removeAllergen();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Clear Allergens'),
                  onPressed: () {
                    _clearAllergens();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Add Recipe'),
                  onPressed: () {
                    _addRecipe();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Get Recipes'),
                  onPressed: () {
                    _getRecipes();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Remove Recipe'),
                  onPressed: () {
                    _removeRecipe();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Clear Recipes'),
                  onPressed: () {
                    _clearRecipes();
                  },
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Add Shopping Item'),
                  onPressed: () {
                    _addShoppingListItem();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Get Shopping List'),
                  onPressed: () {
                    _getShoppingList();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Purchase Shopping Item'),
                  onPressed: () {
                    _purchaseShoppingListItem();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Remove shopping item'),
                  onPressed: () {
                    _removeShoppingListItem();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Clear Shopping List'),
                  onPressed: () {
                    _clearShoppingList();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Get Ingredients'),
                  onPressed: () {
                    _getIngredients();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Clear Ingredients'),
                  onPressed: () {
                    _clearIngredients();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Add Ingredient'),
                  onPressed: () {
                    _addIngredient();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Add Server Ingredients'),
                  onPressed: () {
                    _addAllIngredients();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Examples on how to use local db and local storage

  _loginUser() async {
    String token = await BackendRequest.login('dayyan', 'coolpassword123');// login user from db
    LocalStorage.storeAuthToken(token);// stores token locally
    print(await LocalStorage.getAuthToken());// grabs token locally
  }

  _removeToken() async {
    LocalStorage.deleteAuthToken();// removes token locally
    print(await LocalStorage.getAuthToken());// checks if its not there should be -1
  }

  _addAllergen() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    Allergen allergen = Allergen(id: 3, name: 'Nuts');//creates an allergen use actual id and name
    await helper.insertAllergen(allergen);//adds an allergen locally
    print(await helper.allergens());//returns a list of all allergens the user has
  }

  _getAllergens() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    print(await helper.allergens());//returns a list of all allergens the user has
  }

  _removeAllergen() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteAllergen('Nuts');// removes allergen with name Nuts locally
    print('removed allergen: Nuts');
    print(await helper.allergens());//returns a list of all allergens the user has
  }

  _clearAllergens() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.clearAllergens();// removes all local allergens
    print(await helper.allergens());//returns a list of all allergens the user has
  }

  _addRecipe() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    //creates a favorite recipe, use actual id, name, and url of recipe from db
    Recipe rec = Recipe(id: 2, name: 'Noodles', img: 'https://noodles.jpg');
    await helper.insertRecipe(rec);//adds a recipe locally
    print(await helper.recipes());//returns a list of all recipes the user has
  }

  _getRecipes() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    print(await helper.recipes());//returns a list of all recipes the user has
  }

  _removeRecipe() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteRecipe(2);// removes recipe with id 2 locally
    print('removed recipe: 2');
    print(await helper.recipes());//returns a list of all recipes the user has
  }

  _clearRecipes() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.clearRecipes();// removes all local recipes
    print(await helper.recipes());//returns a list of all recipes the user has
  }

  _addShoppingListItem() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    //creates a shopping list item, use actual ingredient name and quantity
    ShoppingList sl = ShoppingList(ingredient: 'Oranges', quantity: 3, purchased: false);
    await helper.insertShoppingListItem(sl);//adds a shopping list item locally
    print(await helper.shoppingListItems());//returns a list of all shopping list items
  }

  _getShoppingList() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    print(await helper.shoppingListItems());//returns a list of all shopping list items
  }

  _purchaseShoppingListItem() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    ShoppingList sl = ShoppingList(ingredient: 'Oranges', quantity: 3, purchased: true);
    await helper.updateShoppingListItem(sl);
    print(await helper.shoppingListItems());//returns a list of all shopping list items
  }

  _removeShoppingListItem() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteShoppingListItem('Oranges');//removes shopping list with ingredient name
    print('removed item: Oranges');
    print(await helper.shoppingListItems());//returns a list of all shopping list items
  }

  _clearShoppingList() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.clearShoppingList();// removes all local shopping list items
    print(await helper.shoppingListItems());// returns a list of all shopping list items
  }

  _getIngredients() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    print(await helper.ingredients());// returns a list of all ingredients
  }

  _clearIngredients() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.clearIngredients();// removes all local ingredients
    print(await helper.ingredients());// returns a list of all ingredients
  }

  _addIngredient() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    Ingredient ing = Ingredient(id: 1, name: 'Tomatoes'); //creates an ingredient
    await helper.insertIngredient(ing); //adds an ingredient locally
    print(await helper.ingredients());// returns a list of all ingredients
  }

  _addAllIngredients() async {
    String token = await LocalStorage.getAuthToken();
    if (token != '-1') {
      int userID = 2; // should grab this from local storage too...
      // or ideally change backendRequest to not need userID
      BackendRequest br = new BackendRequest(token, userID);
      DatabaseHelper helper = DatabaseHelper.instance;

      // gets ingredient list from server
      // adds them to locally if not exist
      await br.getIngredientList().then((ingList) {
        for (dynamic ing in ingList) {
          Ingredient newIng = Ingredient(name: ing.name, id: ing.id);
          helper.insertIngredient(newIng);
        }
      });

      // display all ingredients...
      print(await helper.ingredients());// returns a list of all ingredients

    } else {
      print("User is not logged in.");
    }
  }

}