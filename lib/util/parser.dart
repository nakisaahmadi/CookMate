import 'dart:convert';
import 'package:cookmate/cookbook.dart';

class Parser {

  static Recipe recipe (String json) => new Recipe.fromJSON(jsonDecode(json));

  static List<Recipe> searchResults (String json) {

    // Parse JSON 
    var searchData = jsonDecode(json);
    List<dynamic> results = searchData["results"];
    List<Recipe> recipes = new List(results.length);

    // Check valid
    if(results == null)
    {
      print("Error: Invalid JSON entered for search results");
      return null;
    }

    // Convert list of JSON objects to list of Recipe objects
    for(int i = 0; i < results.length; i++)
    {
      recipes[i] = new Recipe.fromJSON(results[i]);
      print(recipes[i]);
    }

    return recipes;
  }
}