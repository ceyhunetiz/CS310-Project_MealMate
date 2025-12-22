class Meal {
  final String id;
  final String title;
  final String price;
  final String time;
  final String createdBy;
  final DateTime createdAt;
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.title,
    required this.price,
    required this.time,
    required this.createdBy,
    required this.createdAt,
    required this.ingredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'time': time,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'ingredients': ingredients,
    };
  }

  factory Meal.fromMap(String id, Map<String, dynamic> map) {
    final rawIngredients = map['ingredients'];

    List<String> parsedIngredients = [];
    if (rawIngredients is List) {
      parsedIngredients = rawIngredients.map((e) => e.toString()).toList();
    }

    return Meal(
      id: id,
      title: (map['title'] ?? '').toString(),
      price: (map['price'] ?? '€0').toString(),
      time: (map['time'] ?? 'N/A').toString(),
      createdBy: (map['createdBy'] ?? '').toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ingredients: parsedIngredients,
    );
  }
}