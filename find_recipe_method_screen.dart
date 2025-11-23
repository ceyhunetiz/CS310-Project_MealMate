import 'package:flutter/material.dart';

class FindRecipeMethodScreen extends StatelessWidget {
  const FindRecipeMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Find Recipe',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'How do you want to find your recipe?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),

              const SizedBox(height: 32),

              // By Budget card
              _OptionCard(
                backgroundColor: const Color(0xFFD9EEFF), // fill
                borderColor: const Color(0xFFB9EBFF),      // stroke
                iconBackground: const Color(0xFF111111),
                iconColor: Colors.white,
                title: 'By Budget',
                subtitle:
                    'Enter your spending range (₺)\nLeads to Budget Finder → Results',
                onTap: () {
                  // hook to your Budget screen
                },
              ),

              const SizedBox(height: 24),

              // By Ingredients card
              _OptionCard(
                backgroundColor: const Color(0xFFFFF4C9), // fill
                borderColor: const Color(0xFFFDBA74),      // stroke
                iconBackground: const Color(0xFFFFC857),   // carrot color-ish
                iconColor: const Color(0xFF111111),
                title: 'By Ingredients',
                subtitle:
                    'Pick what you already have\nLinks to Emir’s ingredient screen',
                onTap: () {
                  // hook to your Ingredients screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackground,
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
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wallet, // pick what matches your Figma
                size: 22,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
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
