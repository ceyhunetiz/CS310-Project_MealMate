import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class DatabaseService {
  final CollectionReference _mealsCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<void> addMeal(
    String title,
    String price,
    String time,
    String userId, {
    List<String> ingredients = const [],
  }) async {
    await _mealsCollection.add({
      'title': title,
      'price': price,
      'time': time,
      'ingredients': ingredients,
      'createdBy': userId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Meal>> getMeals() {
    return _mealsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Meal.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> updateMeal(
    String id, {
    String? title,
    String? price,
    String? time,
    List<String>? ingredients,
  }) async {
    final Map<String, dynamic> updates = {};

    if (title != null) updates['title'] = title;
    if (price != null) updates['price'] = price;
    if (time != null) updates['time'] = time;
    if (ingredients != null) updates['ingredients'] = ingredients;

    if (updates.isEmpty) return;

    await _mealsCollection.doc(id).update(updates);
  }

  Future<void> deleteMeal(String id) async {
    await _mealsCollection.doc(id).delete();
  }

  Future<void> saveShoppingHistory({
    required String userId,
    required String store,
    required double total,
    required List<String> items,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('shopping_history')
        .add({
      'store': store,
      'total': total,
      'date': DateTime.now().toIso8601String(),
      'items': items,
    });
  }
}