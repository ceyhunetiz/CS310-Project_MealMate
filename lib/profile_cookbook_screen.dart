
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'saved_recipes_screen.dart';
import 'my_uploads_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/app_colors.dart';

class ProfileCookbookScreen extends StatefulWidget {
  const ProfileCookbookScreen({super.key});

  @override
  State<ProfileCookbookScreen> createState() => _ProfileCookbookScreenState();
}

class _ProfileCookbookScreenState extends State<ProfileCookbookScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  
  void _onSettingsTapped() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Settings"),
        content: SwitchListTile(
          title: const Text("Notifications"),
          subtitle: const Text("Receive daily meal tips"),
          value: _notificationsEnabled,
          activeColor: AppColors.primary,
          onChanged: (val) => _toggleNotifications(val),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close",
                style: TextStyle(color: AppColors.primary)),
          )
        ],
      ),
    );
  }

  void _onLogoutTapped() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthService>().signOut();
            },
            child:
                const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFFFC59D)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'My Profile',
                    style: const TextStyle(
            fontFamily: 'Poppins',

                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            
            _buildRecipeCountCard(),

            const SizedBox(height: 32),

            Text('Your Content',
                style: const TextStyle(
            fontFamily: 'Poppins',

                    fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            _navTile(Icons.bookmark_outline, 'Saved Recipes',
                () => Navigator.pushNamed(context, '/savedRecipes')),
            _navTile(Icons.upload_file, 'My Uploads',
                () => Navigator.pushNamed(context, '/myUploads')),

            const SizedBox(height: 32),

            Text('Account',
                style: const TextStyle(
            fontFamily: 'Poppins',

                    fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            _navTile(Icons.settings_outlined, 'Settings', _onSettingsTapped),
            _navTile(Icons.logout, 'Logout', _onLogoutTapped,
                color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCountCard() {
    final user = Provider.of<User?>(context);
    
    if (user == null) {
      return _statCard('Your Recipes', '0', 'recipes', AppColors.primary);
    }

    final databaseService = DatabaseService();
    
    return StreamBuilder(
      stream: databaseService.getMealsByUser(user.uid),
      builder: (context, snapshot) {
        int recipeCount = 0;
        if (snapshot.hasData) {
          recipeCount = snapshot.data!.length;
        }
        
        return _statCard(
          'Your Recipes',
          '$recipeCount',
          recipeCount == 1 ? 'recipe' : 'recipes',
          AppColors.primary,
        );
      },
    );
  }

  Widget _statCard(
      String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(subtitle,
              style:
                  TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _navTile(IconData icon, String text, VoidCallback onTap,
      {Color color = AppColors.primary}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}