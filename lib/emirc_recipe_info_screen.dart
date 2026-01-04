
import 'package:flutter/material.dart';
import 'emirc_shopping_cart_screen.dart';
import 'utils/app_colors.dart'; 

class EmirCRecipeInfoScreen extends StatefulWidget {
  const EmirCRecipeInfoScreen({super.key});

  @override
  State<EmirCRecipeInfoScreen> createState() => _EmirCRecipeInfoScreenState();
}

class _EmirCRecipeInfoScreenState extends State<EmirCRecipeInfoScreen> {
  final List<_IngredientStatus> _ingredients = [
    _IngredientStatus(name: 'Pasta', available: true),
    _IngredientStatus(name: 'Tomato', available: true),
    _IngredientStatus(name: 'Olive Oil', available: false, suggestion: '₺12 Add to Cart'),
  ];

  final List<String> _steps = const [
    'Boil pasta in salted water until al dente.',
    'Dice the tomatoes and sauté with garlic.',
    'Combine pasta with sauce and finish with olive oil.',
  ];

  void _toggleIngredient(int index) {
    setState(() {
      _ingredients[index] = _ingredients[index].copyWith(
        available: !_ingredients[index].available,
      );
    });
  }

  void _startCooking(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cooking timer started! 👩‍🍳'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _openCart(BuildContext context) {
    final missingItems = _ingredients
        .where((ingredient) => !ingredient.available)
        .map((ingredient) => ingredient.name)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmirCShoppingCartScreen(
          missingItems: missingItems,
        ),
      ),
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
          'Recipe Info',
          style: const TextStyle(
            fontFamily: 'Poppins',

            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRecipeHeader(),
              const SizedBox(height: 20),
              _buildInfoChips(),
              const SizedBox(height: 24),
              _buildIngredientsCard(),
              const SizedBox(height: 24),
              _buildStepsCard(),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _startCooking(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start Cooking',
                    style: const TextStyle(
            fontFamily: 'Poppins',

                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () => _openCart(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Add Missing Items to Cart',
                    style: const TextStyle(
            fontFamily: 'Poppins',

                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5), 
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Meal Mate',
                style: const TextStyle(
            fontFamily: 'Poppins',

                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '🍝 Pasta with Tomato Sauce',
            style: const TextStyle(
            fontFamily: 'Poppins',

              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _InfoChip(label: 'Cost: ₺35'),
        _InfoChip(label: 'Time: 12 min'),
        _InfoChip(label: 'Calories: 520 kcal', wide: true),
      ],
    );
  }

  Widget _buildIngredientsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients:',
          style: const TextStyle(
            fontFamily: 'Poppins',

            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _ingredients.length; i++) ...[
                _IngredientRow(
                  ingredient: _ingredients[i],
                  onTap: () => _toggleIngredient(i),
                ),
                if (i != _ingredients.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Steps:',
          style: const TextStyle(
            fontFamily: 'Poppins',

            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(
              _steps.length,
              (index) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                margin: EdgeInsets.only(
                  bottom: index == _steps.length - 1 ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${index + 1}. ${_steps[index]}',
                  style: const TextStyle(
            fontFamily: 'Poppins',

                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.onTap,
  });

  final _IngredientStatus ingredient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool available = ingredient.available;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              available ? Icons.check_circle : Icons.cancel,
              color: available ? const Color(0xFF4CAF50) : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ingredient.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: available ? Colors.black87 : Colors.red,
                  fontWeight: available ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
            if (!available)
              Text(
                ingredient.suggestion ?? '',
                style: const TextStyle(
            fontFamily: 'Poppins',

                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    this.wide = false,
  });

  final String label;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(
        minWidth: wide ? 180 : 120,
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontFamily: 'Poppins',

          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IngredientStatus {
  const _IngredientStatus({
    required this.name,
    required this.available,
    this.suggestion,
  });

  final String name;
  final bool available;
  final String? suggestion;

  _IngredientStatus copyWith({
    String? name,
    bool? available,
    String? suggestion,
  }) {
    return _IngredientStatus(
      name: name ?? this.name,
      available: available ?? this.available,
      suggestion: suggestion ?? this.suggestion,
    );
  }
}