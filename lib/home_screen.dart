import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'find_recipe_method_screen.dart';
import 'emirc_shopping_cart_screen.dart';
import 'profile_cookbook_screen.dart';
import 'services/database_service.dart';
import 'models/meal.dart';
import 'cooking_instructions_screen.dart';

import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
    HomeContent(),
    const FindRecipeMethodScreen(),
    const EmirCShoppingCartScreen(),
    const ProfileCookbookScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: false,
              title: RichText(
                text: TextSpan(
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
                  children: const [
                    TextSpan(
                      text: 'Meal',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: 'Mate',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.black87),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No new notifications'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            )
          : AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: false,
              title: RichText(
                text: TextSpan(
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
                  children: const [
                    TextSpan(
                      text: 'Meal',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: 'Mate',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    String _searchQuery = '';

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search recipes or users...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
              const SizedBox(height: 24),
              if (_searchQuery.isNotEmpty)
                _buildSearchResults(context, _searchQuery)
              else ...[
                Text(
                  "Suggestion of the Day",
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 15),
                _suggestionCard(context),
                const SizedBox(height: 30),
                Text(
                  "Shared by Others",
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 15),
                _sharedByFriends(context),
              ],
            ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    return StreamBuilder<List<Meal>>(
      stream: context.read<DatabaseService>().getMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final allMeals = snapshot.data ?? [];
        final userMeals = allMeals.where((meal) => meal.creatorEmail != null).toList();
        final filteredMeals = userMeals.where((meal) {
          final titleMatch = meal.title.toLowerCase().contains(query);
          final emailMatch = meal.creatorEmail != null &&
              meal.creatorEmail!.toLowerCase().contains(query);
          return titleMatch || emailMatch;
        }).toList();

        if (filteredMeals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No recipes found',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try a different search term',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Results (${filteredMeals.length})',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 15),
            ...filteredMeals.map((meal) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildFriendRecipeCard(context, meal),
            )),
          ],
        );
      },
    );
  }

  Widget _suggestionCard(BuildContext context) {
    return StreamBuilder<List<Meal>>(
      stream: context.read<DatabaseService>().getMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allMeals = snapshot.data ?? [];
        final suggestionMeal = allMeals.isNotEmpty ? allMeals.first : null;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: suggestionMeal != null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CookingInstructionsScreen(meal: suggestionMeal),
                      ),
                    );
                  }
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                    child: Image.asset(
                      'assets/images/suggestion_image.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.restaurant_menu,
                              size: 60, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Suggestion",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        suggestionMeal?.title ?? "No recipes yet",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        suggestionMeal != null
                            ? "${suggestionMeal.price} • ${suggestionMeal.time} • ${suggestionMeal.ingredients.length} ingredients"
                            : "Upload a recipe to see suggestions!",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sharedByFriends(BuildContext context) {
    return StreamBuilder<List<Meal>>(
      stream: context.read<DatabaseService>().getMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allMeals = snapshot.data ?? [];
        final userMeals = allMeals.where((meal) => meal.creatorEmail != null).toList();

        if (userMeals.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'No recipes shared yet',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        return Column(
          children: userMeals.take(5).map((meal) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: _buildFriendRecipeCard(context, meal),
          )).toList(),
        );
      },
    );
  }

  Widget _buildFriendRecipeCard(BuildContext context, Meal meal) {
    final creatorName = meal.creatorEmail?.split('@')[0] ?? 'Unknown';
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CookingInstructionsScreen(meal: meal),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$creatorName shared a meal idea",
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
