import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'models/meal.dart';
import 'utils/app_colors.dart';
import 'emirc_shopping_cart_screen.dart';
import 'services/cart_service.dart';
import 'services/database_service.dart';

class CookingInstructionsScreen extends StatefulWidget {
  final Meal meal;

  const CookingInstructionsScreen({
    super.key,
    required this.meal,
  });

  @override
  State<CookingInstructionsScreen> createState() => _CookingInstructionsScreenState();
}

class _CookingInstructionsScreenState extends State<CookingInstructionsScreen> {
  final Map<int, bool> _stepCompleted = {};
  int _currentStep = 0;
  final CartService _cartService = CartService();
  bool _isSaved = false;
  bool _isLoadingSaved = true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.meal.cookingSteps.length; i++) {
      _stepCompleted[i] = false;
    }
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isSaved = await context.read<DatabaseService>().isRecipeSaved(user.uid, widget.meal.id);
      if (mounted) {
        setState(() {
          _isSaved = isSaved;
          _isLoadingSaved = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingSaved = false;
        });
      }
    }
  }

  Future<void> _toggleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to save recipes'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSaved = !_isSaved;
    });

    try {
      if (_isSaved) {
        await context.read<DatabaseService>().saveRecipe(user.uid, widget.meal.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe saved!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        await context.read<DatabaseService>().unsaveRecipe(user.uid, widget.meal.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe unsaved'),
            backgroundColor: Colors.grey,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaved = !_isSaved;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isInCart(String ingredient) {
    return _cartService.contains(ingredient);
  }

  void _toggleStep(int index) {
    if (index == _currentStep) {
      setState(() {
        _stepCompleted[index] = !(_stepCompleted[index] ?? false);
      });
    }
  }

  void _nextStep() {
    if (_currentStep < widget.meal.cookingSteps.length - 1) {
      setState(() {
        _stepCompleted[_currentStep] = true;
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        for (int i = _currentStep; i < widget.meal.cookingSteps.length; i++) {
          _stepCompleted[i] = false;
        }
        _currentStep--;
      });
    }
  }

  void _addToCart(String ingredient) {
    _cartService.addItem(ingredient);
    setState(() {}); 
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$ingredient added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addAllIngredientsToCart() {
    final ingredients = widget.meal.ingredients;
    
    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No ingredients to add.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int addedCount = 0;
    for (final ingredient in ingredients) {
      if (!_cartService.contains(ingredient)) {
        _cartService.addItem(ingredient);
        addedCount++;
      }
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          addedCount > 0
              ? '$addedCount ingredient${addedCount > 1 ? 's' : ''} added to cart'
              : 'All ingredients are already in cart',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => _openCart(),
        ),
      ),
    );
  }

  void _openCart() {
    final cartItems = _cartService.items;
    
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty. Add ingredients first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmirCShoppingCartScreen(
          missingItems: cartItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.meal.cookingSteps;
    final hasSteps = steps.isNotEmpty;

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
          'Cooking Instructions',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isLoadingSaved)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(
                _isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isSaved ? AppColors.primary : Colors.black,
              ),
              onPressed: _toggleSave,
              tooltip: _isSaved ? 'Unsave recipe' : 'Save recipe',
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: _openCart,
            tooltip: 'Shopping Cart',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRecipeHeader(),
              const SizedBox(height: 24),
              _buildInfoChips(),
              const SizedBox(height: 24),
              _buildIngredientsSection(),
              const SizedBox(height: 24),
              if (hasSteps) ...[
                _buildCookingStepsSection(),
                const SizedBox(height: 24),
              ] else ...[
                _buildNoStepsMessage(),
                const SizedBox(height: 24),
              ],
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.meal.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _InfoChip(
          icon: Icons.attach_money,
          label: widget.meal.price,
        ),
        _InfoChip(
          icon: Icons.access_time,
          label: widget.meal.time,
        ),
        _InfoChip(
          icon: Icons.restaurant,
          label: '${widget.meal.ingredients.length} ingredients',
        ),
        if (widget.meal.cookingSteps.isNotEmpty)
          _InfoChip(
            icon: Icons.list_alt,
            label: '${widget.meal.cookingSteps.length} steps',
          ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_bag, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              'Ingredients',
              style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < widget.meal.ingredients.length; i++) ...[
                _buildIngredientRow(widget.meal.ingredients[i], i),
                if (i != widget.meal.ingredients.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                    indent: 60,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCookingStepsSection() {
    final steps = widget.meal.cookingSteps;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              'Cooking Steps',
              style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(
              steps.length,
              (index) {
                final isCompleted = _stepCompleted[index] ?? false;
                final isCurrentStep = index == _currentStep;
                
                final canToggle = index == _currentStep;
                final isPastStep = index < _currentStep;
                
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index == steps.length - 1 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentStep
                        ? AppColors.primary.withOpacity(0.1)
                        : isPastStep
                            ? Colors.green.withOpacity(0.05)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrentStep
                        ? Border.all(color: AppColors.primary, width: 2)
                        : isPastStep
                            ? Border.all(color: Colors.green.withOpacity(0.3), width: 1)
                            : Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: InkWell(
                    onTap: canToggle ? () => _toggleStep(index) : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.primary
                                  : isCurrentStep
                                      ? AppColors.primary.withOpacity(0.2)
                                      : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: isCurrentStep
                                            ? AppColors.primary
                                            : isPastStep
                                                ? Colors.green[700]
                                                : Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  steps[index],
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: isCompleted
                                        ? Colors.black54
                                        : isPastStep && !isCompleted
                                            ? Colors.black87
                                            : Colors.black87,
                                    fontWeight: isCurrentStep
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                if (!canToggle && !isPastStep) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Complete previous steps first',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                if (isCurrentStep) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Current Step',
                                      style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        if (steps.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _currentStep > 0 ? _previousStep : null,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Previous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor: Colors.grey[100],
                  disabledForegroundColor: Colors.grey[400],
                ),
              ),
              Text(
                'Step ${_currentStep + 1} of ${steps.length}',
                style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _currentStep < steps.length - 1 ? _nextStep : null,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor: Colors.grey[100],
                  disabledForegroundColor: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNoStepsMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No cooking instructions available',
            style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cooking steps will appear here once added to the recipe.',
            style: const TextStyle(
            fontFamily: 'Poppins',

              fontSize: 14,
              color: Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _addAllIngredientsToCart,
        icon: const Icon(Icons.shopping_cart, size: 20),
        label: Text(
          'Add Ingredients to Cart',
          style: const TextStyle(
            fontFamily: 'Poppins',

            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      ),
    );
  }

  Widget _buildIngredientRow(String ingredient, int index) {
    final isInCart = _isInCart(ingredient);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
            fontFamily: 'Poppins',

                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(
            fontFamily: 'Poppins',

                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: isInCart ? null : () => _addToCart(ingredient),
            icon: Icon(isInCart ? Icons.check_circle : Icons.add_shopping_cart, size: 18),
            label: Text(isInCart ? 'Added' : 'Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isInCart ? Colors.grey[300] : AppColors.primary,
              foregroundColor: isInCart ? Colors.grey[700] : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
            fontFamily: 'Poppins',

              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

