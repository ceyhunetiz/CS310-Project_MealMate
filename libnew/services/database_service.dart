import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class DatabaseService {
  final CollectionReference _mealsCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<String> addMeal(
    String title,
    String price,
    String time,
    String userId, {
    List<String> ingredients = const [],
    List<String> cookingSteps = const [],
    String? creatorEmail,
    String? imageUrl,
  }) async {
    final docRef = await _mealsCollection.add({
      'title': title,
      'price': price,
      'time': time,
      'ingredients': ingredients,
      'cookingSteps': cookingSteps,
      'createdBy': userId,
      'creatorEmail': creatorEmail,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now().toIso8601String(),
    });
    return docRef.id;
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

  Stream<List<Meal>> getMealsByUser(String userId) {
    return _mealsCollection
        .where('createdBy', isEqualTo: userId)
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
    List<String>? cookingSteps,
    String? imageUrl,
  }) async {
    final Map<String, dynamic> updates = {};

    if (title != null) updates['title'] = title;
    if (price != null) updates['price'] = price;
    if (time != null) updates['time'] = time;
    if (ingredients != null) updates['ingredients'] = ingredients;
    if (cookingSteps != null) updates['cookingSteps'] = cookingSteps;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;

    if (updates.isEmpty) return;

    await _mealsCollection.doc(id).update(updates);
  }

  Future<void> updateUserProfilePicture(String userId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'profilePictureUrl': imageUrl}, SetOptions(merge: true));
    } catch (e) {
      print('Error updating profile picture: $e');
      rethrow;
    }
  }

  Future<String?> getUserProfilePicture(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return doc.data()?['profilePictureUrl'] as String?;
    } catch (e) {
      
      print('Error getting profile picture: $e');
      return null;
    }
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

  Future<void> saveRecipe(String userId, String recipeId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userDoc = await userRef.get();
    
    if (userDoc.exists) {
      final savedRecipes = List<String>.from(userDoc.data()?['savedRecipes'] ?? []);
      if (!savedRecipes.contains(recipeId)) {
        savedRecipes.add(recipeId);
        await userRef.update({'savedRecipes': savedRecipes});
      }
    } else {
      await userRef.set({'savedRecipes': [recipeId]});
    }
  }

  Future<void> unsaveRecipe(String userId, String recipeId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userDoc = await userRef.get();
    
    if (userDoc.exists) {
      final savedRecipes = List<String>.from(userDoc.data()?['savedRecipes'] ?? []);
      savedRecipes.remove(recipeId);
      await userRef.update({'savedRecipes': savedRecipes});
    }
  }

  Future<bool> isRecipeSaved(String userId, String recipeId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (userDoc.exists) {
        final savedRecipes = List<String>.from(userDoc.data()?['savedRecipes'] ?? []);
        return savedRecipes.contains(recipeId);
      }
      return false;
    } catch (e) {
      print('Error checking if recipe is saved: $e');
      return false;
    }
  }

  Stream<List<String>> getSavedRecipeIds(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return List<String>.from(data?['savedRecipes'] ?? []);
      }
      return <String>[];
    });
  }

  Stream<List<Meal>> getSavedRecipes(String userId) {
    return getSavedRecipeIds(userId).asyncMap((recipeIds) async {
      if (recipeIds.isEmpty) return <Meal>[];
      
      final recipes = await Future.wait(
        recipeIds.map((id) async {
          try {
            final doc = await _mealsCollection.doc(id).get();
            if (doc.exists) {
              return Meal.fromMap(doc.id, doc.data() as Map<String, dynamic>);
            }
            return null;
          } catch (e) {
            print('Error fetching saved recipe $id: $e');
            return null;
          }
        }),
      );
      
      return recipes.whereType<Meal>().toList();
    });
  }
}