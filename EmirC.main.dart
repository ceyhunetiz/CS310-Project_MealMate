import 'package:flutter/material.dart';
import 'EmirC_recipe_info_screen.dart';

void main() {
  runApp(const EmirCApp());
}

class EmirCApp extends StatelessWidget {
  const EmirCApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal Mate - EmirC Flow',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const EmirCRecipeInfoScreen(),
    );
  }
}

