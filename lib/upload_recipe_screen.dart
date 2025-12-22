import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/database_service.dart';

class UploadRecipeScreen extends StatefulWidget {
  const UploadRecipeScreen({super.key});

  @override
  State<UploadRecipeScreen> createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _timeController = TextEditingController();
  final _ingredientsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _timeController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  List<String> _parseIngredients(String raw) {
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Provider.of<User?>(context, listen: false);
    if (user == null) return;

    await context.read<DatabaseService>().addMeal(
          _nameController.text.trim(),
          _priceController.text.trim().isEmpty ? "€10" : _priceController.text.trim(),
          _timeController.text.trim().isEmpty ? "15 min" : _timeController.text.trim(),
          user.uid,
          ingredients: _parseIngredients(_ingredientsController.text),
        );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload', style: TextStyle(color: Colors.black)),
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFB923C)),
                onPressed: _submit,
                child: const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}