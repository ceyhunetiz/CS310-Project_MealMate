class EmailValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmedValue = value.trim();
    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static bool isValid(String email) {
    if (email.trim().isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }
}

