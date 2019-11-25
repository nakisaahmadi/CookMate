import 'package:cookmate/cookbook.dart';
import 'package:cookmate/homePage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';

void main() {

  UserProfile profile = UserProfile(
    id: -1, 
    diet: Diet(
      id: 3, 
      name: "gluten free"
    ),
    allergens: [
      // {
      //   "id": 1,
      //   "name": "Dairy"
      // },
      {
        "id": 8,
        "name": "Shellfish"
      },
    ],
    favorites: [
      {
        "id": 1,
        "api_id": 716429,
        "name": "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
        "url": "https://spoonacular.com/recipeImages/716429-312x231.jpg"
      }
    ]
  );

  BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2, userProfile: profile);
  request.recipeSearch(cuisine: "American", maxCalories: 0, ingredients: ["cheese", "avocado"]).then(
    (recipes) {
      for(Recipe recipe in recipes) {
        print(recipe.toString());
      }
    }
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}