import 'package:cookmate/cookbook.dart' as CB;
import 'package:cookmate/login.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/database_helpers.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cookmate/util/localStorage.dart' as LS;
import 'package:cookmate/multiSelectDialog.dart';


/*
  File: profile.dart
  Functionality: This page handles the user preferences page. It allows the user
  to change their username and password. It also allows the user to set their 
  preferred diet. It also allows for the user to logout which clears all the data
  that is stored locally.
*/

class UserPreferences extends StatefulWidget {
  @override
  _UserPreferences createState() => _UserPreferences();
}

class _UserPreferences extends State<UserPreferences> {

  GlobalKey _scaffold = GlobalKey();
  
  // Backend request object
  BackendRequest request;
  // Local database object
  DatabaseHelper database;

  // User info
  int userID;
  String token;
  int userDiet;

  // Future data for rendering
  Future<String> _userName;
  Future<List<CB.Diet>> _dietList;
  Future<List<CB.Allergen>> _allergenList;
  Future<List<LocalAllergen>> _localAllergens;


  // Page data
  List<String> diets = new List<String>();
  List<String> allAllergens = new List<String>();
  List<String> localAllergens = new List<String>();
  List<String> displayAllergens = new List<String>();

  String userName = "";
  List<DropdownMenuItem<int>> dietsDropDownList =
      new List<DropdownMenuItem<int>>();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    userID = await LS.LocalStorage.getUserID();
    token = await LS.LocalStorage.getAuthToken();
    userDiet = await LS.LocalStorage.getDiet();
    request = new BackendRequest(token, userID);
    database = DatabaseHelper.instance;

    // Fetch information from server
    _getUserProfile();
    _getDiets();
    _getAllergens();

    // Fetch locally stores user's allergens
    _getLocalAllergens();
  }

  /*
    Clear the local storage of all user data
  */
  _clearLocal () {
    LocalStorage.deleteAuthToken();
    LocalStorage.deleteDiet();
    LocalStorage.deleteUserID();
    
    database.clearShoppingList();
    database.clearCalendars();
    database.clearIngredients();
    database.clearRecipes();
    database.clearAllergens();
  }

  /*
    Get the list of all diets
  */
  _getDiets() async {
    _dietList = request.getDietList();
    _dietList.then((currList) {
      setState(() {
        diets.add("None");
        for (int i = 0; i < currList.length; i++) {
          print("Diet: " +
              currList[i].name +
              " id: " +
              currList[i].id.toString());
          diets.add(currList[i].name);
        }
      });
    });
  }

  /*
    Get the list of all allergens
  */
  _getAllergens() async {
    _allergenList = request.getAllergenList(); 
    _allergenList.then((currList) {
      setState(() {
        // allAllergens = currList;
        for (int i = 0; i < currList.length; i++) {
          print("Allergen: " +
              currList[i].name +
              " id: " +
              currList[i].id.toString());
          allAllergens.add(currList[i].name);
        }
        displayAllergens = localAllergens;
      });
    });
  }

  /*
    Get the current username
  */
  _getUserProfile() async {
    _userName = request.getUserName(userID);
    _userName.then((value) {
      setState(() {
        userName = value;
      });
    });
  }

  /*
    Get the current allergens 
  */
  _getLocalAllergens() async {
    _localAllergens = database.allergens();
    _localAllergens.then((currList) {
      setState(() {
        //localAllergens = returnedList;
        for (int i = 0; i < currList.length; i++) {
          print("Allergen: " +
              currList[i].name +
              " id: " +
              currList[i].id.toString());
          localAllergens.add(currList[i].name);
        }
      });
    });
  }

  /*
    Update the diet set for this user profile
  */
  _updateUserDiet(int newDiet) async {
    bool success = false;
    if(newDiet == 0) {
      success = await request.clearDiet();
    } else {
      success = await request.setDiet(newDiet);
    }
    if (success) {
      setState(() {
        LS.LocalStorage.storeDiet(newDiet);
        userDiet = newDiet;
      });
    }
  }

  /*
    Update the username set for this user profile
  */
  Future<bool> _updateUserName(String newUserName) async {
    bool success = await request.updateUsername(userName, newUserName);
    if (success) {
      setState(() {
        userName = newUserName;
      });
    }
    return success;
  }

  /*
    Update the user's allergens locally and on server at same time
    to match those in selectedAllergens
  */
  _updateUserAllergens(List<String> selectedAllergens){
    for (int i = 0; i < allAllergens.length; i++){
      String curr = allAllergens[i];
      int id = i+1;
      //print("CURR: " + curr + " ID: " + id.toString());
      if (selectedAllergens==null){
        if (localAllergens.contains(curr)){
          // REMOVE allergens if previously added but not selected. 
          Future<bool> result = request.removeAllergen(id); 
          result.then((success){
            if (success){
              database.deleteAllergen(curr);
              print("Removed " +  curr + " ID:" + id.toString()+  " from local and server.");
            }
          }); 
        }
      }
      else if (!localAllergens.contains(curr) 
        && selectedAllergens.contains(curr)){
        // ADD allergens if selected and not already added. 
        Future<bool> result = request.addAllergen(id); 
        result.then((success){
          if (success){
            database.insertAllergen(new LocalAllergen(id: id, name: curr));
            print("Added " + curr + " ID:" + id.toString()+ " to local and server.");
          }
        });
      }
      else if (localAllergens.contains(curr) 
        && !selectedAllergens.contains(curr)){
        // REMOVE allergens if previously added but not selected. 
        Future<bool> result = request.removeAllergen(id); 
        result.then((success){
          if (success){
            database.deleteAllergen(curr);
            print("Removed " +  curr + " ID:" + id.toString()+  " from local and server.");
          }
        }); 
      }
      
    }
    
  }

  /*
    Update the password for this user profile
  */
  Future<bool> _updatePassword(String currPassword, String newPassword) async {

    print("Current Password: " + currPassword);
    print("New Password: " + newPassword);
    bool success = await request.updatePassword(currPassword, newPassword);
    if (success) {
      print("New Password was set");
    } else {
      print("Faile to set new Password");
    }
    return success;
  }

  /*
    Delete this user profile
  */
  Future<bool> _deleteUser(String currPassword) async {

    print("Current Password: " + currPassword);
    bool success = await request.deleteUser(currPassword);
    if (success) {
      print("User successfully deleted");
    } else {
      print("Failed to delete user");
    }
    return success;
  }

  /*
    Creates username update dialog
  */
  Future<String> _asyncUsernameInput(BuildContext context) async {

    String newUserName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Username'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(hintText: 'New Username'),
                onChanged: (value) {
                  newUserName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                _updateUserName(newUserName).then((value){
                  if(value){
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      borderWidth: 40,
                      duration:  Duration(seconds: 3),
                      messageText: Text(
                        'Username successfully changed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      backgroundColor: Colors.red[800],
                    )..show(_scaffold.currentContext);
                  }
                  else{
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      borderWidth: 40,
                      duration:  Duration(seconds: 3),
                      messageText: Text(
                        'Invalid username change, please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      backgroundColor: Colors.red[800],
                    )..show(_scaffold.currentContext);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CookmateStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
    Creates Allergens update dialog
  */
  Future<String> _asyncAllergenDialog(BuildContext context) async{

    List<String> selectedAllergens = List();
    selectedAllergens.addAll(localAllergens);
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Allergens'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: MultiSelectChip(
            allAllergens,
            selectedAllergens,
            onSelectionChanged: (selectedList) {
              setState(() {
                selectedAllergens = selectedList;
            });
          }),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                _updateUserAllergens(selectedAllergens);
                setState(() {
                  localAllergens = selectedAllergens;
                  if (selectedAllergens==null){
                    displayAllergens = ["None"];
                    localAllergens = ["None"];
                  }
                  else{
                    displayAllergens = selectedAllergens;
                  } 
                });

                Navigator.of(context).pop();
                /*
                Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => UserPreferences()),
                    );
                */
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CookmateStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
    Creates password update dialog
  */
  Future<String> _asyncPasswordInput(BuildContext context) async {

    String currentPassword = '';
    String newPassword = '';
    String newPasswordConfirm = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Password'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 125,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(hintText: 'Current Password'),
                  onChanged: (value) {
                    currentPassword = value;
                  },
                )),
                new Expanded(
                  child: new TextFormField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(hintText: 'New Password'),
                  onChanged: (value) {
                    newPassword = value;
                  },
                )),
                new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    obscureText: true,
                    decoration: new InputDecoration(
                      hintText: 'Confirm New Password',
                    ),
                    onChanged: (value) {
                      newPasswordConfirm = value;
                  },)
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                if (newPassword!=newPasswordConfirm){
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    flushbarStyle: FlushbarStyle.FLOATING,
                    duration:  Duration(seconds: 3),
                    borderWidth: 40,
                    messageText: Text(
                      "Please make sure your new passwords match.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    backgroundColor: Colors.red[800],
                  )..show(_scaffold.currentContext);
                } else {
                  _updatePassword(currentPassword, newPassword).then((value) {
                    if (value) {
                      print("Success changing password");
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        borderWidth: 40,
                        duration:  Duration(seconds: 3),
                        messageText: Text(
                          'Password successfully changed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        backgroundColor: Colors.red[800],
                      )..show(_scaffold.currentContext);
                    }
                    else{
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        duration:  Duration(seconds: 3),
                        borderWidth: 40,
                        messageText: Text(
                          "Password change invalid, please try again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        backgroundColor: Colors.red[800],
                      )..show(_scaffold.currentContext);
                    }
                  });
                }
                
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CookmateStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
    Creates delete user dialog
  */
  Future<String> _asyncDeleteUserInput(BuildContext context) async {

    String currentPassword = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 125,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "WARNING - This will delete all your user data.", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CookmateStyle.standardRed
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Text("Enter your password to continue:", textAlign: TextAlign.center),
                ),
                new Expanded(
                  child: new TextField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(hintText: 'Password'),
                  onChanged: (value) {
                    currentPassword = value;
                  },
                )),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete User'),
              onPressed: () {
                _deleteUser(currentPassword).then((success) {
                  if (success) {
                    print("Success deleting user");
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  else {
                    Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        duration:  Duration(seconds: 3),
                        borderWidth: 40,
                        messageText: Text(
                          "Unable to delete user, please enter the correct password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        backgroundColor: Colors.red[800],
                      )..show(_scaffold.currentContext);
                  }
                  print("Failed to delete user");
                });
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CookmateStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
    Creates username display
  */
  Widget _displayUserName() {

    return Row(
      children: <Widget>[
        Icon(
          Icons.person_outline,
          color: CookmateStyle.iconGrey,
        ),
        Padding(padding: EdgeInsets.only(left: 30)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Username",
              style: TextStyle(
                fontSize: 15
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 2)),
            Text(
              userName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          "Tap to change",
          style: TextStyle(
            fontWeight: FontWeight.w200
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 50)),
      ],
    );
  }

  /*
    Creates password display
  */
  Widget _displayPassword() {

    return Row(
      children: <Widget>[
        Icon(
          Icons.lock,
          color: CookmateStyle.iconGrey,
        ),
        Padding(padding: EdgeInsets.only(left: 30)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Password",
              style: TextStyle(
                fontSize: 15
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              "*******",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          "Tap to change",
          style: TextStyle(
            fontWeight: FontWeight.w200
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 50)),
      ],
    );
  }

  /*
    Creates allergen display
  */
  Widget _displayAllergens() {

    return Row(
      children: <Widget>[
          Icon(
            Icons.block,
            color: CookmateStyle.iconGrey,
          ),
          
          Padding(padding: EdgeInsets.only(left: 30)),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Allergens",
                style: TextStyle(
                  fontSize: 15
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 2)),
            ],
          ),
          
          Spacer(),
          Text(
            "Tap to change",
            style: TextStyle(
              fontWeight: FontWeight.w200
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 50)),
        ],
      );
  }

  /* 
    Display the user's Diet and open a dropdown to change diet. 
  */
  Widget _displayDietList() {

    int dietKey = 0;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: DropdownButton(
        hint: Row(
          children: <Widget> [
            Text(
              "Your Diet ",
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              userDiet == -1 ? "None" : diets[userDiet],
              style: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            ),
          ]
        ),
        onChanged: (value) {
          setState(() {
            userDiet = value - 1;
            _updateUserDiet(userDiet);
          });
        },
        isExpanded: true,
        iconSize: 35,
        items: diets.map<DropdownMenuItem<int>>((String value) {
          return DropdownMenuItem<int>(
            value: ++dietKey,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  /*
    Creates Logout button
  */
  Widget _buildLogoutBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 120,
      child: RaisedButton(
        elevation: 2,
        onPressed: () {
          request.logout();
          _clearLocal();
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: CookmateStyle.standardRed,
        child: Text('LOGOUT',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
    );
  }

  /*
    Creates delete user button
  */
  Widget _buildDeleteUserBtn() {
    return Container(
      width: 140,
      child: RaisedButton(
        elevation: 2,
        onPressed: () {
          _asyncDeleteUserInput(context);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: CookmateStyle.iconGrey,
        child: Text('DELETE USER',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
    );
  }

  /*
    Build the page
  */
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffold,
      appBar: NavBar(title: "Settings", titleSize: 22, isUserPrefs: true),
      // MAIN BODY
      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Profile",
              style: TextStyle (
                fontWeight: FontWeight.w800,
                fontSize: 25,
                color: CookmateStyle.textGrey
              ),
            ),
          ),
          Flexible(
            child: ListView(
              children: <Widget>[
                OutlineButton(
                  borderSide: BorderSide(
                    width: 0.05,
                  ),
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    print("change username");
                    _asyncUsernameInput(context);
                  },
                  child: FutureBuilder(
                    future: _userName,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text("Loading User Info");
                        case ConnectionState.done:
                          return _displayUserName();
                        default:
                          return Text("Finding user info...");
                      }
                    }
                  )
                ),
                OutlineButton(
                  borderSide: BorderSide(
                    width: 0.05
                  ),
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    print("change Password");
                    _asyncPasswordInput(context);
                  },
                  child: _displayPassword()
                ),
                
                OutlineButton(
                  borderSide: BorderSide(
                    width: 0.05,
                  ),
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    print("Change Allergens");
                    _asyncAllergenDialog(context);
                  },
                  child: FutureBuilder(
                    future: _allergenList,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text("Loading Allergens");
                        case ConnectionState.done:
                          return _displayAllergens();
                        default:
                          return Text("Finding user preferences...");
                      }
                    }
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Column(
                  children: <Widget>[
                    Text("Current Allergens"),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        displayAllergens.length == 0 ? "None" : displayAllergens.join(",  "),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                
                FutureBuilder(
                  future: _dietList,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(child: Text("Loading Diet List")),
                        );
                      case ConnectionState.done:
                        return _displayDietList();
                      default:
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(child: Text("Looking for your diet")),
                        );
                    }
                  }
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLogoutBtn(),
                    _buildDeleteUserBtn()
                  ],
                )
              ],
            ),
          ),
        ]
      )
    );
  }
}

