import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  FirebaseStorage? _storage;
  final ImagePicker _picker = ImagePicker();

  FirebaseStorage get storage {
    _storage ??= FirebaseStorage.instanceFor(
      bucket: 'mealmate-410b7.firebasestorage.app',
    );
    return _storage!;
  }

  
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  
  Future<String?> uploadProfilePicture(String userId, File imageFile) async {
    try {
      final ref = storage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  
  Future<String?> uploadRecipeImage(String recipeId, File imageFile) async {
    try {
      final ref = storage.ref().child('recipe_images/$recipeId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading recipe image: $e');
      return null;
    }
  }

  
  Future<void> deleteProfilePicture(String userId) async {
    try {
      final ref = storage.ref().child('profile_pictures/$userId.jpg');
      await ref.delete();
    } catch (e) {
      print('Error deleting profile picture: $e');
    }
  }

  
  Future<void> deleteRecipeImage(String recipeId) async {
    try {
      final ref = storage.ref().child('recipe_images/$recipeId.jpg');
      await ref.delete();
    } catch (e) {
      print('Error deleting recipe image: $e');
    }
  }
}

