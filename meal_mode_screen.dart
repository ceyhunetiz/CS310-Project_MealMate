//Rayen Tabbasi


import 'package:flutter/material.dart';
import 'find_recipe_method_screen.dart'; 

class MealModeScreen extends StatelessWidget {
  const MealModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
               
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              const SizedBox(height: 10),

        
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter', 
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      TextSpan(
                        text: 'Meal ',
                        style: TextStyle(color: Color(0xFFFB923C)),
                      ),
                      TextSpan(
                        text: 'Mate',
                        style: TextStyle(color: Color(0xFF111111)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

            
              const Text(
                'What do you want to do today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 60),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _MenuCard(
                      backgroundColor: const Color(0xFFDFFFF0),
                      borderColor: const Color(0xFFC6F5E3),
                      icon: Icons.calendar_month,
                      iconColor: const Color(0xFF000000),
                      title: 'Daily Meal Plan',
                      subtitle: 'Plan breakfast, lunch, dinner for today',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Meal Planner coming soon!")),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    _MenuCard(
                      backgroundColor: const Color(0xFFFFE9D6),
                      borderColor: const Color(0xFFFFDBB8),
                      icon: Icons.ramen_dining,
                      iconColor: const Color(0xFF6B7280),
                      title: 'Single Recipe',
                      subtitle: 'Find one recipe right now\nTap → goes to Recipe Type',
                      onTap: () {
                      
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FindRecipeMethodScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),

            const SizedBox(width: 16),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.3,
                    ),
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