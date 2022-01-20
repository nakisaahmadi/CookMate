import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../calendar.dart';
import '../homePage.dart';
import '../profile.dart';
import '../search.dart';
import '../shoppingListPage.dart';

/*
  File: cookmateStyle.dart
  Functionality: This file defines all the standard widgets and colors for the
  UI design to maintain consistency. This included the top navigation bar, colors
  used throughout the app, and the fonts used within the app.
*/

class CookmateStyle {

  static const Color textGrey = Color.fromRGBO(70, 70, 70, 1);
  static const Color iconGrey = Color.fromRGBO(180, 180, 180, 1);
  static const Color standardRed = Colors.redAccent;

  static final ThemeData theme = ThemeData(
    fontFamily: 'Lato',
    primaryColor: standardRed,
  );

  static Widget loadingIcon (String message) {
    return Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          strokeWidth: 2,
        ),
        Container(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w200
            ),
          ),
          padding: EdgeInsets.all(30)
        ),
      ],
    ));
  }
}

class NavBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final double titleSize;
  final bool hasReturn;

  final bool isHome;
  final bool isSearch;
  final bool isShoppingList;
  final bool isCalendar;
  final bool isUserPrefs;

  @override
  final Size preferredSize;

  NavBar(
    {
      this.title, 
      this.titleSize = 30,
      this.hasReturn = true,
      this.isHome = false,
      this.isSearch = false,
      this.isShoppingList = false,
      this.isCalendar = false,
      this.isUserPrefs = false
    }
  ) : preferredSize = Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {

    Widget extraSpacing = Padding(
      padding: title != null ? EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(20)) : EdgeInsets.zero
    );

    return Column(
      children: <Widget>[
        Container(
          color: CookmateStyle.standardRed,
          child: SafeArea(
            child: Container(),
            bottom: false,
          ),
        ),
        Container(
          height: 50,
          color: CookmateStyle.standardRed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              hasReturn ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: ScreenUtil.getInstance().setWidth(20),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ) : extraSpacing,
              title != null ? SizedBox(
                width: ScreenUtil.getInstance().setWidth(120),
                child: Center(
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ) : extraSpacing,
              title != null ? Spacer(flex: 6) : extraSpacing,
              SizedBox(
                width: ScreenUtil.getInstance().setWidth(40),
                child: IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  disabledColor: Colors.black12,
                  iconSize: ScreenUtil.getInstance().setWidth(28),
                  onPressed: isHome ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ),
              SizedBox(
                width: ScreenUtil.getInstance().setWidth(40),
                child: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  disabledColor: Colors.black12,
                  iconSize: ScreenUtil.getInstance().setWidth(25),
                  onPressed: isSearch ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
              ),
              SizedBox(
                width: ScreenUtil.getInstance().setWidth(40),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                  disabledColor: Colors.black12,
                  iconSize: ScreenUtil.getInstance().setWidth(25),
                  onPressed: isShoppingList ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShoppingListPage()),
                    );
                  },
                ),
              ),
              SizedBox(
                width: ScreenUtil.getInstance().setWidth(40),
                child: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Colors.white,
                  disabledColor: Colors.black12,
                  iconSize: ScreenUtil.getInstance().setWidth(25),
                  onPressed: isCalendar ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyCalendar()),
                    );
                  },
                ),
              ),
              SizedBox(
                width: ScreenUtil.getInstance().setWidth(40),
                child: IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.white,
                  disabledColor: Colors.black12,
                  iconSize: ScreenUtil.getInstance().setWidth(25),
                  onPressed: isUserPrefs ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPreferences()),
                    );
                  },
                ),
              ),
              Spacer(flex: 10),
            ],
          )
        ),
        ClipPath(
          child: Container(height: 40, color: CookmateStyle.standardRed),
          clipper: _BottomWaveClipper(),
        )
      ],
    );
  }
}

class _BottomWaveClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 20.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}