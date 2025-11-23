import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meal_mode_screen.dart';

void main() {
  runApp(const MealMateApp());
}

class MealMateApp extends StatelessWidget {
  const MealMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(), // global Inter
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const MealModeScreen(),
    );
  }
}
