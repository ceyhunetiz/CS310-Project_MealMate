//Doruk Kocaman


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'upload_recipe_screen.dart';

class MyUploadsScreen extends StatelessWidget {
  const MyUploadsScreen({super.key});

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
        title: Text(
          'My Uploads',
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFB923C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.upload_file, size: 60, color: Color(0xFFFB923C)),
              ),
              const SizedBox(height: 32),
              Text(
                'No Uploads Yet',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You haven\'t uploaded any recipes yet. Share your favorite recipes with the community!',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UploadRecipeScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 24, color: Colors.white),
                  label: Text('Upload Recipe', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB923C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}