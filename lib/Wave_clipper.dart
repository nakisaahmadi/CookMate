import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  bool reverse;

  WaveClipper({this.reverse = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse) {
      path.lineTo(0.0, size.height - 50);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
      Offset(size.width - (size.width / 3.25), size.height - 85);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();

    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


//Card(
//
//child: Wrap(
//children: <Widget>[
//
//Image.network('https://www.w3schools.com/w3css/img_lights.jpg'),
//ListTile(
//title: Text('heading1'),
//subtitle: Text('subtitle1'),
//),
//],
//),
//),



//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Container(
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(20.0),
//image: DecorationImage(
//image: AssetImage(
//images[index % images.length],
//),
//fit: BoxFit.cover,
//),
//),
//height: 150,
//),
//SizedBox(
//height: 10.0,
//),
//Padding(
//padding: const EdgeInsets.only(left: 5),
//child: Text(
//"Title\nsubTitle".toUpperCase(),
//style: TextStyle(
//color: Colors.black,
//fontSize: 14.0,
//),
//),
//),
//],