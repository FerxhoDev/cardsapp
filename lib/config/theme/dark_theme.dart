
import 'package:flutter/material.dart';

const Color _turquoiseLight = Color(0xFFA0D8D3);
const Color _orangeLight = Color(0xFFFF9656);
const Color _pers = Color(0xFF0bb5a4);

ThemeData darkTheme = ThemeData.from(
  colorScheme: const ColorScheme.dark(
    primary: _pers,
    secondary: _turquoiseLight
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold,
      color: _turquoiseLight,
    ),
  ),
).copyWith(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  iconTheme: const IconThemeData(
    color: _orangeLight,
  ),
);
  
