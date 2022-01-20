import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/*
  File: database_helpers.dart
  Functionality: This file sets up our local database. It stores shopping list 
  items, calendar items, favorites, user ID and auth token. It has methods that
  allow the frontend to communicate and retreive/modidy/store data within the
  database.
*/

// Store favorite recipe locally
class Recipe {
  int id;
  String name;
  String img;

  Recipe({this.id, this.name, this.img});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'img': img};
  }

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, img: $img}';
  }
}

// Store shopping list items locally
class ShoppingList {
  String ingredient;
  double quantity;
  bool purchased = false;
  String measurement;

  ShoppingList({this.ingredient, this.quantity, this.purchased, this.measurement});

  Map<String, dynamic> toMap() {
    return {
      'ingredient': ingredient,
      'quantity': quantity,
      'purchased': purchased == false ? 0 : 1,
      'measurement': measurement
    };
  }

  @override
  String toString() {
    return 'ShoppingList{ingredient: $ingredient, quantity: $quantity, purchased: $purchased}, measurement: $measurement';
  }
}

// Store users allergens locally
class LocalAllergen {
  int id;
  String name;

  LocalAllergen({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Allergen{id: $id, name: $name}';
  }
}


// Store a list of all ingredients locally
class Ingredient {
  int id;
  String name;

  Ingredient({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Ingredient{id: $id, name: $name}';
  }
}

class Calendar {
  int id;
  String date;
  int recipe_id;

  Calendar({this.id, this.date, this.recipe_id});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'recipe_id': recipe_id};
  }

  @override
  String toString() {
    return 'Calendar{id: $id, date: $date, recipe_id: $recipe_id}';
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "CookMateDB.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      create table recipe (
        id integer primary key,
        name text not null,
        img text not null
      )''');
    await db.execute('''
      create table allergen (
        id integer primary key,
        name text not null UNIQUE
      )''');
    await db.execute('''
      create table ingredient (
        id integer primary key,
        name text not null UNIQUE
      )''');
    await db.execute('''
      create table shopping_list (
        ingredient text primary key not null UNIQUE,
        quantity real not null,
        purchased integer default 0,
        measurement text
      )''');
    await db.execute('''
      create table calendar (
        id integer primary key autoincrement,
        date text not null,
        recipe_id integer not null UNIQUE
      )''');
  }

  // Database helper methods:

  // Favorite Recipes
  Future<int> insertRecipe(Recipe recipe) async {
    Database db = await database;
    int id = await db.insert(
      'recipe',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return id;
  }

  Future<void> deleteRecipe(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Recipe from the Database.
    await db.delete(
      'recipe',
      // Use a `where` clause to delete a specific recipe.
      where: "id = ?",
      // Pass the Recipe's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> clearRecipes() async {
    Database db = await database;
    await db.delete('recipe');
  }

  Future<List<Recipe>> recipes() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Recipes.
    final List<Map<String, dynamic>> maps = await db.query('recipe');

    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id'],
        name: maps[i]['name'],
        img: maps[i]['img'],
      );
    });
  }

  // All Ingredients
  Future<int> insertIngredient(Ingredient ing) async {
    Database db = await database;
    int id = await db.insert(
      'ingredient',
      ing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return id;
  }

  Future<void> clearIngredients() async {
    Database db = await database;
    await db.delete('ingredient');
  }

  Future<List<Ingredient>> ingredients() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Ingredients.
    final List<Map<String, dynamic>> maps = await db.query('ingredient');

    // Convert the List<Map<String, dynamic> into a List<Ingredient>.
    return List.generate(maps.length, (i) {
      return Ingredient(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  // Users Shopping List
  Future<int> insertShoppingListItem(ShoppingList sl) async {
    Database db = await database;
    int id = await db.insert(
      'shopping_list',
      sl.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return id;
  }

  Future<void> deleteShoppingListItem(String ing) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the ShoppingList from the Database.
    await db.delete(
      'shopping_list',
      // Use a `where` clause to delete a specific recipe.
      where: "ingredient = ?",
      // Pass the ShoppingList's ingredient as a whereArg to prevent SQL injection.
      whereArgs: [ing],
    );
  }

  Future<void> updateShoppingListItem(ShoppingList sl) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given ShoppingList.
    await db.update(
      'shopping_list',
      sl.toMap(),
      // Ensure that the ShoppingList has a matching ingredient.
      where: "ingredient = ?",
      // Pass the ShoppingList's ingredient as a whereArg to prevent SQL injection.
      whereArgs: [sl.ingredient],
    );
  }

  Future<void> clearShoppingList() async {
    Database db = await database;
    await db.delete('shopping_list');
  }

  Future<List<ShoppingList>> shoppingListItems() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The ShoppingList items.
    final List<Map<String, dynamic>> maps = await db.query('shopping_list');

    // Convert the List<Map<String, dynamic> into a List<ShoppingList>.
    return List.generate(maps.length, (i) {
      return ShoppingList(
        ingredient: maps[i]['ingredient'],
        quantity: maps[i]['quantity'],
        purchased: maps[i]['purchased'] == 0 ? false : true,
        measurement: maps[i]['measurement']
      );
    });
  }

  // User's Allergens
  Future<int> insertAllergen(LocalAllergen allergen) async {
    Database db = await database;
    int id = await db.insert(
      'allergen',
      allergen.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return id;
  }

  Future<void> deleteAllergen(String name) async {
    final db = await database;
    // Remove the Allergen from the Database.
    await db.delete(
      'allergen',
      where: "name = ?",
      whereArgs: [name],
    );
  }

  Future<void> clearAllergens() async {
    Database db = await database;
    await db.delete('allergen');
  }

  Future<List<LocalAllergen>> allergens() async {
    final Database db = await database;
    // Query the table for all The Allergens.
    final List<Map<String, dynamic>> maps = await db.query('allergen');
    // Convert the List<Map<String, dynamic> into a List<Allergen>.
    return List.generate(maps.length, (i) {
      return LocalAllergen(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  // User's Calendar
  Future<int> insertCalendar(Calendar cal) async {
    Database db = await database;
    int id = await db.insert(
      'calendar',
      cal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return id;
  }

  Future<void> deleteCalendar(int id) async {
    final db = await database;
    // Remove the Calendar from the Database.
    await db.delete(
      'calendar',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> clearCalendars() async {
    Database db = await database;
    await db.delete('calendar');
  }

  Future<List<Calendar>> calendars() async {
    final Database db = await database;
    // Query the table for all The Calendars.
    final List<Map<String, dynamic>> maps = await db.query('calendar');
    // Convert the List<Map<String, dynamic> into a List<Calendar>.
    return List.generate(maps.length, (i) {
      return Calendar(
        id: maps[i]['id'],
        date: maps[i]['date'],
        recipe_id: maps[i]['recipe_id']
      );
    });
  }

}
