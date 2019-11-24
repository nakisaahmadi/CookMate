import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
  int quantity;
  bool purchased = false;

  ShoppingList({this.ingredient, this.quantity, this.purchased});

  Map<String, dynamic> toMap() {
    return {
      'ingredient': ingredient,
      'quantity': quantity,
      'purchased': purchased == false ? 0 : 1
    };
  }

  @override
  String toString() {
    return 'ShoppingList{ingredient: $ingredient, quantity: $quantity, purchased: $purchased}';
  }
}

// Store users allergens locally
class Allergen {
  int id;
  String name;

  Allergen({this.id, this.name});

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
        quantity integer not null,
        purchased integer default 0
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
      );
    });
  }

  // User's Allergens
  Future<int> insertAllergen(Allergen allergen) async {
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

  Future<List<Allergen>> allergens() async {
    final Database db = await database;
    // Query the table for all The Allergens.
    final List<Map<String, dynamic>> maps = await db.query('allergen');
    // Convert the List<Map<String, dynamic> into a List<Allergen>.
    return List.generate(maps.length, (i) {
      return Allergen(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

}
