import 'package:cookmate/homePage.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/database_helpers.dart' as DB;
import 'cookbook.dart';
import 'createAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './util/backendRequest.dart';
import './util/localStorage.dart';
import 'package:flushbar/flushbar.dart';

/*
  File: login.dart
  Functionality: This file displays the login page for the app. It it the first
  page that the user will be presented with upon launching the app for the first 
  time. It allows the user to login with an already created account or allows them
  to sign up and navigates them to the create account page.
*/

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  //user info
  int userID;
  String _username, _password, _token;
  
  bool _loggingIn = false;

  @override
  initState() {
    _loggingIn = false;
    super.initState();
  }

  Future<bool> _pullUserDataFromServer(BackendRequest backend) async {

    print("Pulling user data from server");
    UserProfile profile = await backend.getUserProfile();
    DB.DatabaseHelper database = DB.DatabaseHelper.instance;

    // Load diet fresh
    if(profile.diet != null) {
      LocalStorage.deleteDiet();
      LocalStorage.storeDiet(profile.diet.id);
      print("Loaded diet ${profile.diet.id}");
    }
    
    // Load allergens fresh
    if(profile.allergens != null) {
      database.clearAllergens();
      for(Map<String, dynamic> allergen in profile.allergens) {
        database.insertAllergen(DB.LocalAllergen(id: allergen['id'], name: allergen['name']));
        print("Loaded allergen ${allergen['id']}");
      }
    }
    // Load favorites fresh
    if(profile.favorites != null) {
      database.clearRecipes();
      for(Map<String, dynamic> recipe in profile.favorites) {
        database.insertRecipe(DB.Recipe(id: recipe['api_id'], name: recipe['name'], img: recipe['url']));
        print("Loaded favorite recipe ${recipe['api_id']}");
      }
    }
    return true;
  }
  
  //Validating the credentials to login, if not display an error
  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _loggingIn = true;
      });

      Future<String> potentialToken = BackendRequest.login(_username, _password);
      potentialToken.then((token) {
        LocalStorage.storeAuthToken(token);
        _token = token;
        //cheking the validation of auth token 
        if (_token != null &&
            _token != "Unable to log in with provided credentials.") {
          BackendRequest backend = new BackendRequest(_token, null);
          //geting the userId from backend and store it in the local storage
          backend.getUser().then((userID){
            LocalStorage.storeUserID(userID);
            _pullUserDataFromServer(backend).then(
              (success) {
                print("Logged in, going to home");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            );
          });
        } else {
          setState(() {
            _loggingIn = false;
          });

          //clear the username & password feilds
          _formKey.currentState.reset();

          //displaying an error message for failing to login
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            borderWidth: 40,
            messageText: Text(
              'Unable to log in with provided credentials.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            backgroundColor: Colors.red[800],
          )..show(context);
        }
      });
    }
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            autocorrect: false,
            style: TextStyle(
              color: CookmateStyle.standardRed,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15.0),
                prefixIcon: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.red[100],
                ),
                hintText: 'Enter your Username',
                hintStyle: TextStyle(
                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.bold)
                ),
            validator: (input) =>
            input.trim().isEmpty ? 'Please enter a valid username' : null,
            onSaved: (input) => _username = input,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            autocorrect: false,
            obscureText: true,
            style: TextStyle(
              color: CookmateStyle.standardRed,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.red[100],
                ),
                hintText: 'Enter your Password',
                hintStyle: TextStyle(
                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.bold)
                ),
            validator: (input) =>
            input.length < 6 ? 'Must be at least 6 characters' : null,
            onSaved: (input) => _password = input,
          ),
        ),
      ],
    );
  }

  //building the login button
  Widget _buildLoginBtn() {

    return !_loggingIn ? Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 0.0,
        onPressed: () {
          _submit();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.black26,
        child: Text('LOGIN',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
      ),
    ) : Padding(
      padding: EdgeInsets.all(30),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black38)
      )
    );
  }

  //building the sing up option
  Widget _buildSignUpBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account?',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: '  Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CookmateStyle.standardRed,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  child: Column(
                    children: <Widget> [
                      SafeArea(child: Container()),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 130,
                            child: Image(image: AssetImage('assets/logo/chef.png'))
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Cookmate.",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: [ 
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 8
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildUsernameTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPasswordTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildLoginBtn(),
                            _buildSignUpBtn()
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}