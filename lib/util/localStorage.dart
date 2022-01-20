import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/*
  File: localStorage.dart
  Functionality: 
*/

class LocalStorage {

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

  /* Method: storeDiet
   * Arg(s):
   *    - diet: The diet set by the user
   * 
   * Return: n/a
   */
  static void storeDiet (int diet) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("diet", diet);
  }

  /* Method: getDiet
   * Arg(s): n/a
   * 
   * Return:
   *  - success: The locally stored diet
   *  - failure: "-1"
   */
  static Future<int> getDiet () async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("diet") ?? -1;
  }

  /* Method: deleteDiet
   * Arg(s): n/a
   * Return: n/a
   */
  static void deleteDiet () async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("diet");
  }
}