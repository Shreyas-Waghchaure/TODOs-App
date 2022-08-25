import 'package:flutter/material.dart';
import 'package:letsdoapp/screens/HomePage.dart';
void main() {
  runApp(MaterialApp(
   debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.deepOrange
    ),
    home: HomePage(),
  ));
}
