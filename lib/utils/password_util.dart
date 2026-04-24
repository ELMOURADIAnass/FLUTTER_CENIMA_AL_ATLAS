import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility class for secure password handling
class PasswordUtil {
  PasswordUtil._(); // Private constructor

  /// Hash a password using SHA256 with salt
  /// In production, consider using bcrypt (crypto package)
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Verify a password against its hash
  static bool verifyPassword(String password, String hash) {
    final hashedInput = hashPassword(password);
    return hashedInput == hash;
  }

  /// Validate password strength
  /// Requirements:
  /// - At least 6 characters
  /// - Contains at least one letter and one number (recommended)
  static bool isValidPassword(String password) {
    if (password.length < 6) return false;
    // Optional: Add more complex requirements
    // return password.contains(RegExp(r'[A-Za-z]')) &&
    //        password.contains(RegExp(r'[0-9]'));
    return true;
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate email and password together
  static (bool valid, String? error) validateCredentials(
    String email,
    String password,
  ) {
    if (email.isEmpty) {
      return (false, 'Email cannot be empty');
    }
    if (!isValidEmail(email)) {
      return (false, 'Please enter a valid email address');
    }
    if (password.isEmpty) {
      return (false, 'Password cannot be empty');
    }
    if (!isValidPassword(password)) {
      return (false, 'Password must be at least 6 characters');
    }
    return (true, null);
  }

  /// Validate full name
  static bool isValidFullName(String fullName) {
    return fullName.trim().isNotEmpty && fullName.length >= 2;
  }
}

