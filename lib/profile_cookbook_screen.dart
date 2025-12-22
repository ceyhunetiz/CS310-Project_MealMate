// Doruk Kocaman - Updated for Step 3 Logic

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // REQUIRED: For Auth
import 'package:shared_preferences/shared_preferences.dart'; // REQUIRED: For Rubric Item 11

import 'saved_recipes_screen.dart';
import 'my_uploads_screen.dart';
import 'shopping_history_screen.dart';
// import 'main.dart'; // No longer needed because we use AuthService

import 'services/auth_service.dart'; // REQUIRED

class ProfileCookbookScreen extends StatefulWidget {
  const ProfileCookbookScreen({super.key});

  @override
  State<ProfileCookbookScreen> createState() => _ProfileCookbookScreenState();
}

class _ProfileCookbookScreenState extends State<ProfileCookbookScreen> {
  int savedMoney = 320;
  int recipeCount = 6;
  
  // LOGIC: State variable for our preference
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // LOGIC: Load the preference from disk (Rubric Requirement)
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  // LOGIC: Save the preference to disk
  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  void _copyCode(BuildContext context) {
    const codeText = 'MealMate Profile Shared!';
    Clipboard.setData(const ClipboardData(text: codeText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile link copied!'),
        backgroundColor: const Color(0xFFFB923C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToSavedRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedRecipesScreen()),
    );
  }

  void _navigateToMyUploads() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyUploadsScreen()),
    );
  }

  void _navigateToShoppingHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShoppingHistoryScreen()),
    );
  }

  // LOGIC: Updated to show a real preference toggle
  void _onSettingsTapped() {
    showDialog(
      context: context,
      builder: (context) {
        // We use StatefulBuilder so the switch updates visually inside the dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Settings"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Manage your app preferences."),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text("Notifications"),
                    subtitle: const Text("Receive daily meal tips"),
                    value: _notificationsEnabled,
                    activeThumbColor: const Color(0xFFFB923C),
                    onChanged: (val) {
                      // Update the main state
                      _toggleNotifications(val);
                      // Update the dialog state
                      setDialogState(() {});
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close", style: TextStyle(color: Color(0xFFFB923C))),
                )
              ],
            );
          },
        );
      },
    );
  }

  // LOGIC: Updated to actually sign out
  void _onLogoutTapped() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // 1. Close the dialog
                Navigator.pop(context);
                // 2. Sign out via Firebase
                context.read<AuthService>().signOut();
                // 3. Close the profile screen so we fall back to the Wrapper
                Navigator.pop(context);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
          'My Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _copyCode(context),
            icon: const Icon(Icons.copy, color: Colors.black54),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFB923C), Color(0xFFFFC59D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFB923C).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, size: 40, color: Color(0xFFFB923C)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'My Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.savings_outlined,
                      title: 'Saved Money',
                      value: '₺$savedMoney',
                      subtitle: 'this month 🎉',
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.restaurant_menu,
                      title: 'Your Recipes',
                      value: '$recipeCount',
                      subtitle: 'recipes',
                      color: const Color(0xFFFB923C),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Your Content',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              _buildTabButton(
                icon: Icons.bookmark_outline,
                text: 'Saved Recipes',
                onTap: _navigateToSavedRecipes,
              ),
              const SizedBox(height: 12),
              _buildTabButton(
                icon: Icons.upload_file,
                text: 'My Uploads',
                onTap: _navigateToMyUploads,
              ),
              const SizedBox(height: 12),
              _buildTabButton(
                icon: Icons.shopping_bag_outlined,
                text: 'Shopping History',
                onTap: _navigateToShoppingHistory,
              ),

              const SizedBox(height: 32),

              Text(
                'Account',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              _buildActionButton(
                icon: Icons.settings_outlined,
                text: 'Settings',
                onTap: _onSettingsTapped,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.logout,
                text: 'Logout',
                color: Colors.red,
                onTap: _onLogoutTapped,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String title, required String value, required String subtitle, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildTabButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFB923C), size: 24),
            const SizedBox(width: 16),
            Text(text, style: GoogleFonts.poppins(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.black38, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String text, Color? color, required VoidCallback onTap}) {
    final buttonColor = color ?? const Color(0xFFFB923C);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: buttonColor, size: 24),
            const SizedBox(width: 16),
            Text(text, style: GoogleFonts.poppins(color: buttonColor, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}