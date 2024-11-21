import 'package:flutter/material.dart';

const primaryColor = Colors.yellow;
const backGroundColor = Color(0xFF000620);
const mainTextColour = Color.fromARGB(255, 121, 17, 62);
const secondTextColour = Colors.white;
final ThemeData themdata = ThemeData(
  scaffoldBackgroundColor: backGroundColor,
  primaryColor:
      backGroundColor, 
  textTheme: const TextTheme(
    bodyMedium:
        TextStyle(color: Colors.white),                    
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: backGroundColor,  
    iconTheme: IconThemeData(color: Colors.white), 
  ),
);
