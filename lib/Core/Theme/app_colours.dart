import 'package:flutter/material.dart';

//main colours>>>>>>>>>>>>>>>>>>>>>>>>>>>
const primaryColor = Colors.white;
const backGroundColor = Color(0xFF000620);

//text colours>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

const mainTextColour = Color(0xFF6426AC);
const mainTextColour2 = Color.fromARGB(255, 147, 30, 30);

const secondTextColour = Colors.white;
const blackColor = Colors.black;
const maintexttheme =
    TextStyle(color: mainTextColour, fontWeight: FontWeight.w800, fontSize: 18);
const secondaryTextTheme = TextStyle(
    color: secondTextColour, fontWeight: FontWeight.w800, fontSize: 18);

final ThemeData themdata = ThemeData(
  scaffoldBackgroundColor: backGroundColor,
  primaryColor: backGroundColor,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: backGroundColor,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);
