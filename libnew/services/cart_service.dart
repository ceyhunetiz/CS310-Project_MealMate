class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  void addItem(String item) {
    if (!_items.contains(item)) {
      _items.add(item);
    }
  }

  void removeItem(String item) {
    _items.remove(item);
  }

  void clear() {
    _items.clear();
  }

  bool contains(String item) {
    return _items.contains(item);
  }
}




