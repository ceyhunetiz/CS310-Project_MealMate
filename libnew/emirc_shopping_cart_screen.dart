import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/database_service.dart';
import 'services/cart_service.dart';
import 'services/ingredient_translator.dart';
import 'utils/app_colors.dart';

class EmirCShoppingCartScreen extends StatefulWidget {
  const EmirCShoppingCartScreen({super.key, this.missingItems});

  final List<String>? missingItems;

  @override
  State<EmirCShoppingCartScreen> createState() =>
      _EmirCShoppingCartScreenState();
}

class _EmirCShoppingCartScreenState
    extends State<EmirCShoppingCartScreen> {
  List<_CartIngredient> _cartItems = [];
  final CartService _cartService = CartService();
  static const List<String> _availableStores = [
    'Migros',
  ];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  @override
  void didUpdateWidget(EmirCShoppingCartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCartItems();
  }

  void _loadCartItems() {
    final allCartItems = _cartService.items;
    final List<_CartIngredient> loadedItems = [];
    for (final itemName in allCartItems) {
      if (!_cartItems.any((item) => item.name == itemName)) {
        loadedItems.add(_CartIngredient(
          name: itemName,
          selectedStore: _cartItems.isNotEmpty 
              ? _cartItems.first.selectedStore 
              : 'Migros', 
        ));
      }
    }
    if (widget.missingItems != null && widget.missingItems!.isNotEmpty) {
      for (final itemName in widget.missingItems!) {
        if (!_cartItems.any((item) => item.name == itemName) && 
            !allCartItems.contains(itemName)) {
          _cartService.addItem(itemName);
          loadedItems.add(_CartIngredient(
            name: itemName,
            selectedStore: _cartItems.isNotEmpty 
                ? _cartItems.first.selectedStore 
                : 'Migros',
          ));
        }
      }
    }

    if (loadedItems.isNotEmpty) {
      setState(() {
        _cartItems.addAll(loadedItems);
      });
    }
    setState(() {
      _cartItems.removeWhere((item) => !allCartItems.contains(item.name));
    });
  }

  String _getStoreSearchUrl(String store, String ingredient) {
    final turkishIngredient = IngredientTranslator.translate(ingredient);
    final encodedQuery = Uri.encodeComponent(turkishIngredient);
    
    switch (store.toLowerCase()) {
      case 'migros':
        return 'https://www.migros.com.tr/arama?q=$encodedQuery';
      case 'carrefour':
      case 'carrefoursa':
        return 'https://www.carrefoursa.com/arama?q=$encodedQuery';
      case 'trendyol':
      case 'trendyol market':
        return 'https://www.trendyol.com/sr?q=$encodedQuery';
      case 'a101':
        return 'https://www.a101.com.tr/arama?q=$encodedQuery';
      case 'bim':
        return 'https://www.bim.com.tr/arama?q=$encodedQuery';
      case 'şok':
      case 'sok':
        return 'https://www.sokmarket.com.tr/arama?q=$encodedQuery';
      default:
        return 'https://www.google.com/search?q=${Uri.encodeComponent(store + " " + ingredient)}';
    }
  }

  String? get _selectedStore {
    if (_cartItems.isEmpty) return null;
    final firstStore = _cartItems.first.selectedStore;
    
    
    final allSame = _cartItems.every((item) => item.selectedStore == firstStore);
    return allSame ? firstStore : null;
  }

  void _deleteIngredient(int index) {
    final itemToRemove = _cartItems[index];
    _cartService.removeItem(itemToRemove.name);
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _updateAllStores(String storeName) {
    setState(() {
      for (final item in _cartItems) {
        item.selectedStore = storeName;
      }
    });
  }

  Future<void> _launchStoreSearch(String ingredient, String store) async {
    try {
      final url = _getStoreSearchUrl(store, ingredient);
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $store website. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _checkout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first!')),
      );
      return;
    }

    
    final selectedStore = _selectedStore;
    if (selectedStore == null || _cartItems.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a store for all ingredients.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    
    try {
      final storeUrl = _getStoreSearchUrl(selectedStore, '');
      
      final mainUrl = storeUrl.split('?')[0];
      final uri = Uri.parse(mainUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $selectedStore website. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    
    try {
      await context.read<DatabaseService>().saveShoppingHistory(
            userId: user.uid,
            store: selectedStore,
            total: 0.0, 
            items: _cartItems.map((e) => e.name).toList(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening $selectedStore website...'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: Text(
          'Shopping Cart',
          style: const TextStyle(
            fontFamily: 'Poppins',

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
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: _cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'No items in cart',
                          style: const TextStyle(
            fontFamily: 'Poppins',

                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _cartItems.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return _CartIngredientTile(
                            ingredient: item,
                            availableStores: _availableStores,
                            selectedStore: item.selectedStore,
                            onStoreChanged: (store) {
                              setState(() {
                                item.selectedStore = store;
                                
                                _updateAllStores(store);
                              });
                            },
                            onDelete: () => _deleteIngredient(index),
                            onStoreLinkTap: (store) {
                              _launchStoreSearch(item.name, store);
                            },
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: (_cartItems.isEmpty || _selectedStore == null) ? null : _checkout,
                child: Text(
                  _selectedStore != null
                      ? 'Open $_selectedStore Website'
                      : 'Select a store',
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
    );
  }

}

class _CartIngredientTile extends StatelessWidget {
  const _CartIngredientTile({
    required this.ingredient,
    required this.availableStores,
    required this.selectedStore,
    required this.onStoreChanged,
    required this.onDelete,
    required this.onStoreLinkTap,
  });

  final _CartIngredient ingredient;
  final List<String> availableStores;
  final String? selectedStore;
  final ValueChanged<String> onStoreChanged;
  final VoidCallback onDelete;
  final ValueChanged<String> onStoreLinkTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFAB76),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ingredient.name,
                  style: const TextStyle(
            fontFamily: 'Poppins',

                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Remove ingredient',
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Column(
          children: availableStores.map((store) {
            final isSelected = store == selectedStore;
            return GestureDetector(
              onTap: () => onStoreChanged(store),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEAF3FF)
                      : const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        store,
                        style: const TextStyle(
            fontFamily: 'Poppins',

                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.link, size: 18),
                      color: AppColors.primary,
                      onPressed: () => onStoreLinkTap(store),
                      tooltip: 'View $store options for ${ingredient.name}',
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CartIngredient {
  _CartIngredient({
    required this.name,
    required this.selectedStore,
  });

  final String name;
  String selectedStore;
}