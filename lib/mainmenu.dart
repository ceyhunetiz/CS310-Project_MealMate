//Ceyhun Etiz

import 'profile_cookbook_screen.dart';
import 'package:flutter/material.dart';
import 'ingredients_page.dart';
import 'meal_mode_screen.dart';
import 'emirc_recipe_info_screen.dart';
import 'emirc_shopping_cart_screen.dart';


class MainMenu extends StatefulWidget {
  final String userName;

  const MainMenu({super.key, required this.userName});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              Text(
                "Hello, ${widget.userName}! 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Poppins', 
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search ingredient or recipe",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFB923C)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Actions:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              _buildMenuButton("My Profile", Icons.person, Colors.blueGrey, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileCookbookScreen()));
              }),
              const SizedBox(height: 15),
              
              _buildMenuButton("Ingredient-Based Recipes", Icons.search, Colors.black87, () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const IngredientsPage())
                );
              }),
              
              const SizedBox(height: 15),
              
              _buildMenuButton("Meal Mode", Icons.restaurant_menu, Colors.blueGrey, () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const MealModeScreen())
                );
              }),
              
              const SizedBox(height: 15),
              _buildMenuButton("Shopping List", Icons.shopping_cart, Colors.grey, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmirCShoppingCartScreen())
                );
              }),
              const SizedBox(height: 15),
              _buildMenuButton("Random Recipe", Icons.refresh, Colors.blueGrey, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmirCRecipeInfoScreen())
                );
              }),

              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFB923C), 
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.95],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Weekly Budget Saved:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No savings recorded",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2), 
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFB923C),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0, 
        ),
        onPressed: onTap, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const SizedBox(width: 8), 
            Icon(icon, size: 22, color: iconColor), 
          ],
        ),
      ),
    );
  }
}