import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            //clipper: WaveClipper(),
            child: Container(
              height: 220.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
//                    begin: Alignment.bottomCenter,
//                    end: Alignment.topCenter,
                  colors: [ Color(0xFFB71C1C), Color(0xFFE53935),Color(0xFFD50000)],
                ),
              ),


            ),
          ),
          Stack(
            children: <Widget>[
              Positioned(
                top: 25.0,
                left: 150.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.home),
                      color: Colors.white,
                      iconSize: 50.0,
                      onPressed: () {
                        print('pressed');
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 25.0,
                left: 220.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      iconSize: 50.0,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 25.0,
                left: 290.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.white,
                      iconSize: 50.0,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 25.0,
                left: 360.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu),
                      color: Colors.white,
                      iconSize: 50.0,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Positioned(
                top: 90.0,
                child: SizedBox(
                  height: 10.0,
                  width: 500.0,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Positioned(
                top: 100.0,
                left: 20.0,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Today',
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 15.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 5.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100.0,
                left: 130.0,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Popular',
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 15.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 5.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100.0,
                left: 265.0,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Favorite',
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 15.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 5.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Positioned(
                top: 180.0,
                left: 345.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      color: Color(0xFFD50000),
                      iconSize: 50.0,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
//
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 228.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Favorite Recipes'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 250.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: _buildItem,
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),

                SizedBox(height: 7.0),
                Container(
                  height: 250.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => _buildItem(context, index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, index) {
    String mealName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 210.0,
              width: 170.0,
              child: Image.network(
                  'https://previews.123rf.com/images/rawpixel/rawpixel1510/rawpixel151025608/47062607-food-table-celebration-delicious-party-meal-concept.jpg',
                  fit: BoxFit.cover),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              width: 170.0,
              height: 60.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
//                    begin: Alignment.bottomCenter,
//                    end: Alignment.topCenter,
                    colors: [ Colors.black54, Colors.black54],
                  ),
                ),


              ),
            ),
            Positioned(
              top: 185.0,
              left: 125.0,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.stars),
                    color: Colors.white,
                    iconSize: 20.0,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Positioned(
              top: 210.0,
              left: 125.0,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    iconSize: 20.0,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Positioned(
              left: 40.0,
              bottom: 10.0,
              child: Column(
                children: <Widget>[
                  Text(
                    'MealName',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17.0),
                  ),
                  Text(
                    'subtitle',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}