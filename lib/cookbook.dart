import 'package:flutter/material.dart';

class Recipe {

  int id;
  String title;
  String imageURL;
  int servings;
  int cookTime;
  Map<String, dynamic> json;

  Recipe.fromJSON(Map<String, dynamic> json) : this.json = json {

    id = json['id'];
    title = json['title'];
    imageURL = json['image'];
    servings = json['servings'];
    cookTime = json['readyInMinutes'];
  }

  Image get image => Image.network(imageURL);

  @override String toString() => "Recipe: $title \nServings: $servings \nCook Time: $cookTime minutes";
}

class Ingredient {
  
  int id;
  String name;

  Ingredient.fromJSON(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
  }
}

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