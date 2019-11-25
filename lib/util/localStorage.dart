import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookmate/cookbook.dart';

class LocStorage {

  /* Method: storeAuthToken
   * Arg(s):
   *    - authToken: The auth token associated with a user after login
   * 
   * Return: n/a
   */
  static void storeAuthToken (String authToken) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("auth", authToken);
  }

  /* Method: getAuthToken
   * Arg(s): n/a
   * 
   * Return:
   *  - success: The locally stored auth token
   *  - failure: "-1"
   */
  static Future<String> getAuthToken () async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth") ?? "-1";
  }

  /* Method: deleteAuthToken
   * Arg(s): n/a
   * Return: n/a
   */
  static void deleteAuthToken () async {

    final prefs = await SharedPreferences.getInstance();
    prefs.remove("auth");
  }

  /* Method: storeUserID
   * Arg(s):
   *    - userID: The ID of the user
   * 
   * Return: n/a
   */
  static void storeUserID (int userID) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("user_id", userID);
  }

  /* Method: getUserID
   * Arg(s): n/a
   * 
   * Return:
   *  - success: The locally stored user ID
   *  - failure: "-1"
   */
  static Future<int> getUserID () async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id") ?? -1;
  }

  /* Method: deleteUserID
   * Arg(s): n/a
   * Return: n/a
   */
  static void deleteUserID () async {

    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
  }

  /* Method: storeUserProfile
   * Arg(s):
   *    - userID: The ID of the user
   * 
   * Return: n/a
   */
  static void storeUserProfile (UserProfile userProfile) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("up_id", userProfile.id);
    prefs.setInt("ud_id", userProfile.diet.id);

    prefs.setInt("all_count", userProfile.allergens.length);
    for(int i = 0; i < userProfile.allergens.length; i++) {
      prefs.setString("all_$i", userProfile.allergens[i]['name']);
    }

    prefs.setInt("fav_count", userProfile.favorites.length);
    for(int i = 0; i < userProfile.favorites.length; i++) {
      prefs.setString("fav_$i", userProfile.favorites[i]['name']);
    }
  }
}