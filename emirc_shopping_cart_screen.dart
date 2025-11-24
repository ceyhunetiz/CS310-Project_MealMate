//Emir Ceylan

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmirCShoppingCartScreen extends StatefulWidget {
  const EmirCShoppingCartScreen({super.key, this.missingItems});

  final List<String>? missingItems;

  @override
  State<EmirCShoppingCartScreen> createState() => _EmirCShoppingCartScreenState();
}

class _EmirCShoppingCartScreenState extends State<EmirCShoppingCartScreen> {
  late final List<_CartIngredient> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [
      _CartIngredient(
        name: 'Olive Oil',
        options: const [
          StorePrice(store: 'Migros', price: 28),
          StorePrice(store: 'Carrefour', price: 31),
          StorePrice(store: 'Trendyol Market', price: 29),
        ],
        selectedStore: 'Migros',
      ),
      _CartIngredient(
        name: 'Pasta',
        options: const [
          StorePrice(store: 'Migros', price: 12),
          StorePrice(store: 'Carrefour', price: 14),
        ],
        selectedStore: 'Migros',
      ),
    ];

    if (widget.missingItems != null && widget.missingItems!.isNotEmpty) {
      final normalizedMissing = widget.missingItems!
          .map((item) => item.toLowerCase())
          .toSet();
      _cartItems.retainWhere(
        (item) => normalizedMissing.contains(item.name.toLowerCase()),
      );
    }
  }

  double get _cartTotal {
    return _cartItems.fold<double>(
      0,
      (sum, item) => sum + item.selectedPrice,
    );
  }

  String get _checkoutStoreLabel {
    if (_cartItems.isEmpty) {
      return 'Store';
    }
    return _cartItems.first.selectedStore;
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
          'Shopping Cart',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  itemCount: _cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return _CartIngredientTile(
                      ingredient: item,
                      onSelectionChanged: (store) {
                        setState(() => item.selectedStore = store);
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTotalCard(),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB923C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: _cartItems.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Checkout started at $_checkoutStoreLabel'),
                            backgroundColor: const Color(0xFFFB923C),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                child: Text(
                  'Checkout at Store → $_checkoutStoreLabel',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            'Total:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            '₺${_cartTotal.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartIngredientTile extends StatelessWidget {
  const _CartIngredientTile({
    required this.ingredient,
    required this.onSelectionChanged,
  });

  final _CartIngredient ingredient;
  final ValueChanged<String> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFAB76), // Slightly lighter orange for chips
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            ingredient.name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: ingredient.options.map((option) {
            final bool isSelected = option.store == ingredient.selectedStore;
            return GestureDetector(
              onTap: () => onSelectionChanged(option.store),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEAF3FF) : const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      option.store,
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₺${option.price.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '→ Selected: ${ingredient.selectedStore}',
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CartIngredient {
  _CartIngredient({
    required this.name,
    required this.options,
    required this.selectedStore,
  });

  final String name;
  final List<StorePrice> options;
  String selectedStore;

  double get selectedPrice {
    final match = options.firstWhere(
      (option) => option.store == selectedStore,
      orElse: () => options.first,
    );
    return match.price;
  }
}

class StorePrice {
  const StorePrice({
    required this.store,
    required this.price,
  });

  final String store;
  final double price;
}