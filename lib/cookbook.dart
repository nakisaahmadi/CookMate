import 'package:flutter/material.dart';

/*
  File: cookbook.dart
  Functionality: This file defines several classes and functions that are
  used throughout the app.
*/

/* Class: Recipe
 * Description: Recipe object with basic data about a recipe, including its title, image, servings, etc...
 *              More data regarding the recipe can be retrieved from its embedded JSON.
 */
class Recipe {

  bool _complete;

  int id;
  int apiID;
  String title;
  String imageURL;
  int servings;
  int cookTime;
  double price;
  double calories;
  int popularity;
  Map<String, dynamic> _json;

  Recipe.simple(this.apiID, this.title, this.imageURL);
  Recipe.simpleJSON(Map<String, dynamic> json) {
    apiID = json['api_id'];
    title = json['name'];
    imageURL = json['url'];
  }
  Recipe.complete(Map<String, dynamic> json) : _json = json {

    apiID = json['id'];
    title = json['title'];
    if(json['image'] != null) {
      imageURL = json['image'];
    } else {
      imageURL = json['imageURL'];
    }
    servings = json['servings'];
    cookTime = json['readyInMinutes'];
    if(json['pricePerServing'] != null) {
      price = (servings * json['pricePerServing']).roundToDouble() / 100;
    } else {
      price = (servings * json['pricePerServings']).roundToDouble() / 100;
    }
    if(json['calories'] == null) {
      calories = 0;
    } else {
      calories = json['calories'].toDouble();
    }
    _complete = true;
  }

  //Returns all the ingredients for a given recipe
  List<Ingredient> getIngredients(){
    List<Ingredient> ingredients = new List<Ingredient>();

    List<dynamic> ingredientList = json["extendedIngredients"];

    for(int i =0; i < ingredientList.length; i++){
      String units = ingredientList[i]['unit'];
      units.toLowerCase();
      if(units.contains('spoon') || units == ' teaspoons'){
        if(units.contains('able')){
          units = 'tbsp';
        }
        else{
          units = 'tsp';
        }

      }
      Ingredient ing = new Ingredient(ingredientList[i]['id'], ingredientList[i]['name'], ingredientList[i]['amount'], units);
      ingredients.add(ing);
    }
    //print(ingredients.toString());
    return ingredients;
  }

  //Returns the instructions in a list
  List<String> getInstructions(){
    List<String> instructions = new List<String>();

    if(json["instructions"] == null || json["instructions"] == ""){
      return null;
    }

    var instructionList = json["analyzedInstructions"][0][
    "steps"];

    for(Map<String,dynamic> step in instructionList){
      instructions.add(step["step"]);
    }

    //print(instructions.toString());

    return instructions;
  }

  Image get image => Image.network(imageURL);
  Map<String, dynamic> get json => _json;
  bool get isComplete => _complete;

  @override
  String toString() => """\n
      $title
      ----------------------------
      id:         $id
      api:        $apiID
      image:      $imageURL
      servings:   $servings
      cook time:  $cookTime
      price:      $price 
      calories:   $calories
      popularity: $popularity
      hasJson:    $_complete
    """;
}

/* Class: Ingredient
 * Description: Ingredient object containing its name, and id.
 */
class Ingredient {

  int id;
  String name;
  double quantity;
  String units;

  Ingredient(int id, String name, double quantity, String units){
    this.id = id;
    this.name = name;
    this.quantity = quantity;
    this.units = units;
  }

  Ingredient.fromJSON(Map<String, dynamic> json) : id = json['id'], name = json['name'];
}

/* Class: Cuisine
 * Description: Cuisine object containing its name, and id.
 */
class Cuisine {

  final int id;
  final String name;


  Cuisine.fromJSON(Map<String, dynamic> json) : id = json['id'], name = json['name'];
}

/* Class: Diet
 * Description: Diet object containing its name, summary, and id.
 */
class Diet {

  int id;
  String name;
  String summary;

  Diet ({int id, String name, String summary}) : this.id = id, this.name = name, this.summary = summary;

  Diet.fromJSON(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
    summary = json['summary'];
  }

  Diet.forUP(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
  }
}

/* Class: Allergen
 * Description: Allergen object containing its name and id.
 */
class Allergen {

  int id;
  String name;
  String summary;

  Allergen ({int id, String name}) : this.id = id, this.name = name;

  Allergen.fromJSON(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
  }

  Allergen.forUP(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

/* Class: UserProfile
 * Description: Diet object containing its name, summary, and id.
 */
class UserProfile {

  int id;
  Diet diet;
  List<Map<String, dynamic>> allergens;
  List<Map<String, dynamic>> favorites;

  UserProfile({ int id, Diet diet, List<Map<String, dynamic>> allergens, List<Map<String, dynamic>> favorites }) : this.allergens = allergens, this.diet = diet, this.id = id;
  UserProfile.fromJSON(Map<String, dynamic> json) {

    id = json['id'];
    var diet = json['diet'];
    if(diet != null)
    {
      this.diet = Diet.forUP(diet);
    } else {
      this.diet = null;
    }
    var allergens = json['allergens'];
    if(allergens != null)
    {
      this.allergens = List<Map<String, dynamic>>.from(allergens);
    } else {
      this.allergens = List<Map<String, dynamic>>();
    }
    var favorites = json['favorites'];
    if(favorites != null)
    {
      this.favorites = List<Map<String, dynamic>>.from(favorites);
    } else {
      this.favorites = List<Map<String, dynamic>>();
    }
  }

  String allergenList () {

    String list = "";
    for(Map<String, dynamic> allergen in allergens) {
      list += "${allergen['name']}, ";
    }

    return list.substring(0, list.length - 2);
  }

  @override String toString() {

    String string = "\n\nUser $id\n-------------";
    string += "\nDiet: ${diet.toString()}";
    string += "\nAllergens: ";
    for(int i = 0; i < allergens.length; i++)
    {
      string += "(${allergens[i]["name"]}, ${allergens[i]["id"]}), ";
    }
    string += "\nFavorites: ";
    for(int i = 0; i < favorites.length; i++)
    {
      string += "(${favorites[i]["name"]}, ${favorites[i]["api_id"]}), ";
    }
    return string;
  }
}

class Date {

  final int _year, _month, _day;
  Date(int year, int month, int day) : _year = year, _month = month, _day = day;
  Date.fromJSON(String json) :
        _year = int.tryParse(json.substring(0, 4)),
        _month = int.tryParse(json.substring(5, 7)),
        _day = int.tryParse(json.substring(8, 10));

  String get getDate => "$_year-$_month-$_day";
  @override String toString() => getDate;
}

class Meal {
  final int _id;
  final Recipe _recipe;
  final Date _date;
  Meal(int id, Recipe recipe, Date date) : this._id  = id, this._recipe = recipe,this._date = date;
  Meal.fromJSON(Recipe recipe, Map<String, dynamic> json) :
        _id = json['id'],
        _recipe = recipe,
        _date = Date.fromJSON(json['date']);
  Recipe get recipe => _recipe;
  int get id => _id;
  Date get date => _date;
  @override String toString() => "Meal ID $_id is a ${_recipe.title} on ${_date.getDate}";
}