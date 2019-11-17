import 'package:flutter/material.dart';
import 'package:http/http.dart';

/* Class: Recipe
 * Description: Recipe object with basic data about a recipe, including its title, image, servings, etc...
 *              More data regarding the recipe can be retrieved from its embedded JSON.
 */
class Recipe {

  int id;
  String title;
  String imageURL;
  int servings;
  int cookTime;
  Map<String, dynamic> _json;

  Recipe(int id) : this.id = id;

  Recipe.fromJSON(Map<String, dynamic> json) : _json = json {

    id = json['id'];
    title = json['title'];
    imageURL = json['image'];
    servings = json['servings'];
    cookTime = json['readyInMinutes'];
  }

  Image get image => Image.network(imageURL);
  Map<String, dynamic> get json => _json;

  @override String toString() => "Recipe: $title \nServings: $servings \nCook Time: $cookTime minutes";
}

/* Class: Ingredient
 * Description: Ingredient object containing its name, and id.
 */
class Ingredient {
  
  int id;
  String name;

  Ingredient.fromJSON(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
  }
}

/* Class: Diet
 * Description: Diet object containing its name, summary, and id.
 */
class Diet {

  int id;
  String name;
  String summary;

  Diet.fromJSON(Map<String, dynamic> json) {
    
    id = json['id'];
    name = json['name'];
    summary = json['summary'];
  }
}

/* Class: UserProfile
 * Description: Diet object containing its name, summary, and id.
 */
class UserProfile {

  int id;
  Map<String, dynamic> diet;
  List<Map<String, dynamic>> allergens;

  UserProfile(int id, Map<String, dynamic> diet, List<Map<String, dynamic>> allergens) : this.allergens = allergens, this.diet = diet, this.id = id;
  UserProfile.fromJSON(Map<String, dynamic> json) {
    
    id = json['id'];
    var diet = json['diet'];
    if(diet != null)
    {
      this.diet = diet;
    } else {
      this.diet = Map<String, dynamic>();
    }
    var allergens = json['allergens'];
    if(allergens != null)
    {
      this.allergens = List<Map<String, dynamic>>.from(allergens);
    } else {
      this.allergens = List<Map<String, dynamic>>();
    }
  }

  @override String toString() {

    String string = "\n\nUser $id\n-------------";
    string += "\nDiet: ${diet.toString()}";
    string += "\nAllergens: ";
    for(int i = 0; i < allergens.length; i++)
    {
      string += "(${allergens[i]["name"]}, ${allergens[i]["id"]}), ";
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

  Meal(int id, Recipe recipe, Date date) : _id = id, _recipe = recipe, _date = date;
  Meal.fromJSON(Recipe recipe, Map<String, dynamic> json) : _recipe = recipe, _id = json['id'], _date = Date.fromJSON(json['date']);

  int get id => _id;
  Recipe get recipe => _recipe;
  Date get date => _date;
  @override String toString() => "Meal $_id is a ${_recipe.title} on ${_date.getDate}";
}