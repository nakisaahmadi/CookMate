import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './util/backendRequest.dart';
import 'homePage.dart';
import 'package:flushbar/flushbar.dart';

/*
  File: createAccount.dart
  Functionality: This file handles creating a new account. It allows the user 
  to enter a username, email, and password to create an account with us. It
  adds the user to our backend and logs the user in upon a successful account
  creation.
*/

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final _formKey = GlobalKey<FormState>();

  //user info
  String _username, _email, _password, _confirmedPassword;


  //reset the input fields and display the error for non-valid credentials
  error() {
    _formKey.currentState.reset();
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      overlayBlur: 5.0,
      messageText: Text(
        'Unable to Sign Up with provided credentials.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.red[800],
      duration: Duration(seconds: 3),
    )..show(context);
  }

  //Check if the given credentials are valid then navigate to homepage, esle display error
  _submit() async {  
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_password == _confirmedPassword) {
        int _id = await BackendRequest.createUser(_email, _username, _password);
        if (_id != null) {
            //login the user with created username & pass
            String token = await BackendRequest.login(_username, _password);
            if(token != null) {
                //store the auth token and it to the local storage
                LocalStorage.storeAuthToken(token);
                LocalStorage.storeUserID(_id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
            } else {error();}
        } else {error();}
      } else {error();}
    } else{error();}
  }
  
 
  
  //building the username field
  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                Icons.supervised_user_circle,
                color: Colors.red[100],
              ),
              hintText: 'Enter your Username',
              hintStyle: TextStyle(
                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            validator: (input) =>
                input.trim().isEmpty ? 'Please enter a valid username' : null,
            onSaved: (input) => _username = input,
          ),
        ),
      ],
    );
  }

  //building the email field and validating the email input
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: CookmateStyle.standardRed,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.email,
                color: Colors.red[100],
              ),
              contentPadding: EdgeInsets.all(15),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(
                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            validator: (input) => !EmailValidator.Validate(input, true)
                ? 'Please provide a valid email.'
                : null,
            onSaved: (input) => _email = input,
          ),
        ),
      ],
    );
  }

  //building the password field and validating the password input
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                prefixIcon: Icon(
                  Icons.lock_open,
                  color: Colors.red[100],
                ),
                contentPadding: EdgeInsets.all(15),
                hintText: 'Enter your Password',
                hintStyle: TextStyle(
                    color: Colors.red[300],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            validator: (input) =>
                input.length < 6 ? 'Must be at least 6 characters' : null,
            onSaved: (input) => _password = input,
          ),
        ),
      ],
    );
  }

  //building the password field and validating the confirmed password input
  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                hintText: 'Confirm your Password',
                hintStyle: TextStyle(
                    color: Colors.red[300],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            validator: (input) =>
                input.length < 6 ? 'Must be at least 6 characters' : null,
            onSaved: (input) => _confirmedPassword = input,
          ),
        ),
      ],
    );
  }

  //building the sign up button
  Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.only(top: 25.0, bottom: 10),
      width: double.infinity,
      child: RaisedButton(
        elevation: 0,
        onPressed: () {
          _submit();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black26,
        child: Text('SIGN UP',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Padding(
                        padding: EdgeInsets.only(top: 75, bottom: 25),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: [ 
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 4
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
                              height: 20.0,
                            ),
                            _buildUsernameTF(),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildEmailTF(),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildPasswordTF(),
                            _buildConfirmPasswordTF(),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildSignUpBtn(),
                          ],
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back to Login",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18
                          ),
                        ),
                      )
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
