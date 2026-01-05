import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/database_service.dart';
import 'models/meal.dart';
import 'utils/app_colors.dart';

class UploadRecipeScreen extends StatefulWidget {
  final Meal? mealToEdit;
  
  const UploadRecipeScreen({super.key, this.mealToEdit});

  @override
  State<UploadRecipeScreen> createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _timeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _cookingStepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    if (widget.mealToEdit != null) {
      _nameController.text = widget.mealToEdit!.title;
      _priceController.text = widget.mealToEdit!.price;
      _timeController.text = widget.mealToEdit!.time;
      _ingredientsController.text = widget.mealToEdit!.ingredients.join(', ');
      _cookingStepsController.text = widget.mealToEdit!.cookingSteps.join('\n');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _timeController.dispose();
    _ingredientsController.dispose();
    _cookingStepsController.dispose();
    super.dispose();
  }

  List<String> _parseIngredients(String raw) {
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  List<String> _parseCookingSteps(String raw) {
    return raw
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Provider.of<User?>(context, listen: false);
    if (user == null) return;

    final databaseService = context.read<DatabaseService>();

    if (widget.mealToEdit != null) {
      
      await databaseService.updateMeal(
        widget.mealToEdit!.id,
        title: _nameController.text.trim(),
        price: _priceController.text.trim().isEmpty ? "€10" : _priceController.text.trim(),
        time: _timeController.text.trim().isEmpty ? "15 min" : _timeController.text.trim(),
        ingredients: _parseIngredients(_ingredientsController.text),
        cookingSteps: _parseCookingSteps(_cookingStepsController.text),
      );
    } else {
      
      await databaseService.addMeal(
        _nameController.text.trim(),
        _priceController.text.trim().isEmpty ? "€10" : _priceController.text.trim(),
        _timeController.text.trim().isEmpty ? "15 min" : _timeController.text.trim(),
        user.uid,
        ingredients: _parseIngredients(_ingredientsController.text),
        cookingSteps: _parseCookingSteps(_cookingStepsController.text),
        creatorEmail: user.email,
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealToEdit != null ? 'Edit Recipe' : 'Upload',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (e.g. €25)'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (e.g. 15 min)'),
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Ingredients (comma separated)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cookingStepsController,
                decoration: const InputDecoration(
                  labelText: 'Cooking Steps (one per line)',
                  hintText: 'Step 1: Boil water\nStep 2: Add pasta\nStep 3: Cook for 10 minutes',
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                minLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: _submit,
                child: Text(
                  widget.mealToEdit != null ? 'Update Recipe' : 'Submit',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}