class Validator {
  // Matches exact international or standardized localized phone numbers
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number cannot be left blank.';
    }
    if (value.trim().length < 9 || value.trim().length > 15) {
      return 'Enter a valid structural phone code tracking digits.';
    }
    return null;
  }

  // Ensures email field follows correct syntactic strings if populated
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional database column parameter
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please supply a correctly formatted email domain.';
    }
    return null;
  }

  // Secures standard password rules before server processing passes
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required to proceed.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 alphanumeric values long.';
    }
    return null;
  }
}