//Doruk Kocaman
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingHistoryScreen extends StatelessWidget {
  const ShoppingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Shopping History', style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: const Color(0xFFFB923C).withOpacity(0.5)),
            const SizedBox(height: 20),
            Text('No History Yet', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}