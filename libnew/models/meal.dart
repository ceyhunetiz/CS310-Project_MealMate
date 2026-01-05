class Meal {
  final String id;
  final String title;
  final String price;
  final String time;
  final String createdBy;
  final String? creatorEmail;
  final String? imageUrl;
  final DateTime createdAt;
  final List<String> ingredients;
  final List<String> cookingSteps;

  Meal({
    required this.id,
    required this.title,
    required this.price,
    required this.time,
    required this.createdBy,
    this.creatorEmail,
    this.imageUrl,
    required this.createdAt,
    required this.ingredients,
    this.cookingSteps = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'time': time,
      'createdBy': createdBy,
      'creatorEmail': creatorEmail,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'ingredients': ingredients,
      'cookingSteps': cookingSteps,
    };
  }

  factory Meal.fromMap(String id, Map<String, dynamic> map) {
    final rawIngredients = map['ingredients'];
    final rawSteps = map['cookingSteps'];

    List<String> parsedIngredients = [];
    if (rawIngredients is List) {
      parsedIngredients = rawIngredients.map((e) => e.toString()).toList();
    }

    List<String> parsedSteps = [];
    if (rawSteps is List) {
      parsedSteps = rawSteps.map((e) => e.toString()).toList();
    }

    return Meal(
      id: id,
      title: (map['title'] ?? '').toString(),
      price: (map['price'] ?? '€0').toString(),
      time: (map['time'] ?? 'N/A').toString(),
      createdBy: (map['createdBy'] ?? '').toString(),
      creatorEmail: map['creatorEmail']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ingredients: parsedIngredients,
      cookingSteps: parsedSteps,
    );
  }
}