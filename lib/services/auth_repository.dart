import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../utils/password_util.dart';

/// Repository for authentication and user data management
/// Handles all auth operations and local storage
class AuthRepository {
  static const String usersBoxName = 'users';
  static const String sessionBoxName = 'session';

  static Box<dynamic>? _usersBox;
  static Box<dynamic>? _sessionBox;

  /// Initialize authentication database
  static Future<void> initialize() async {
    _usersBox = await Hive.openBox(usersBoxName);
    _sessionBox = await Hive.openBox(sessionBoxName);
  }

  /// Register a new user
  /// Returns (success, message)
  static Future<(bool, String)> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Validate inputs
      final (isValid, error) =
          PasswordUtil.validateCredentials(email.toLowerCase().trim(), password);
      if (!isValid) {
        return (false, error ?? 'Invalid credentials');
      }

      if (!PasswordUtil.isValidFullName(fullName)) {
        return (false, 'Please enter a valid full name');
      }

      // Check if email already exists
      final existingUser = _findUserByEmail(email.toLowerCase().trim());
      if (existingUser != null) {
        return (false, 'Email already registered');
      }

      // Create new user
      final user = User(
        id: const Uuid().v4(),
        email: email.toLowerCase().trim(),
        fullName: fullName.trim(),
        hashedPassword: PasswordUtil.hashPassword(password),
        createdAt: DateTime.now(),
      );

      // Save user to local storage
      await _usersBox?.put(user.email, user.toMap());

      // Create session
      await _createSession(user);

      return (true, 'Registration successful');
    } catch (e) {
      return (false, 'Registration failed: ${e.toString()}');
    }
  }

  /// Login user with email and password
  /// Returns (success, message)
  static Future<(bool, String)> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      final (isValid, error) =
          PasswordUtil.validateCredentials(email.toLowerCase().trim(), password);
      if (!isValid) {
        return (false, error ?? 'Invalid email or password');
      }

      // Find user
      final userMap = _usersBox?.get(email.toLowerCase().trim());
      if (userMap == null) {
        return (false, 'User not found');
      }

      final user = User.fromMap(Map<String, dynamic>.from(userMap as Map));

      // Verify password
      if (!PasswordUtil.verifyPassword(password, user.hashedPassword)) {
        return (false, 'Invalid email or password');
      }

      // Update last login
      final updatedUser = user.copyWith(lastLogin: DateTime.now());
      await _usersBox?.put(user.email, updatedUser.toMap());

      // Create session
      await _createSession(updatedUser);

      return (true, 'Login successful');
    } catch (e) {
      return (false, 'Login failed: ${e.toString()}');
    }
  }

  /// Get currently logged-in user
  static User? getCurrentUser() {
    try {
      final userEmail = _sessionBox?.get('currentUserEmail') as String?;
      if (userEmail == null) return null;

      final userMap = _usersBox?.get(userEmail);
      if (userMap == null) return null;

      return User.fromMap(Map<String, dynamic>.from(userMap as Map));
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _sessionBox?.get('currentUserEmail') != null;
  }

  /// Logout current user
  static Future<void> logout() async {
    try {
      await _sessionBox?.clear();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  /// Update user profile
  static Future<(bool, String)> updateProfile({
    required String fullName,
  }) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        return (false, 'No user logged in');
      }

      if (!PasswordUtil.isValidFullName(fullName)) {
        return (false, 'Please enter a valid full name');
      }

      final updatedUser = currentUser.copyWith(fullName: fullName.trim());
      await _usersBox?.put(currentUser.email, updatedUser.toMap());
      await _sessionBox?.put('currentUserEmail', updatedUser.email);

      return (true, 'Profile updated successfully');
    } catch (e) {
      return (false, 'Update failed: ${e.toString()}');
    }
  }

  /// Change user password
  static Future<(bool, String)> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        return (false, 'No user logged in');
      }

      // Verify current password
      if (!PasswordUtil.verifyPassword(currentPassword, currentUser.hashedPassword)) {
        return (false, 'Current password is incorrect');
      }

      // Validate new password
      if (!PasswordUtil.isValidPassword(newPassword)) {
        return (false, 'New password must be at least 6 characters');
      }

      if (currentPassword == newPassword) {
        return (false, 'New password must be different from current password');
      }

      // Update password
      final updatedUser = currentUser.copyWith(
        hashedPassword: PasswordUtil.hashPassword(newPassword),
      );
      await _usersBox?.put(currentUser.email, updatedUser.toMap());

      return (true, 'Password changed successfully');
    } catch (e) {
      return (false, 'Password change failed: ${e.toString()}');
    }
  }

  /// Get all registered users (admin/debug only)
  static List<User> getAllUsers() {
    try {
      final maps = _usersBox?.values.toList() ?? [];
      return maps
          .map((m) => User.fromMap(Map<String, dynamic>.from(m as Map)))
          .toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      return [];
    }
  }

  /// Close all boxes
  static Future<void> close() async {
    await _usersBox?.close();
    await _sessionBox?.close();
  }

  // Private helpers

  /// Create a session for a user
  static Future<void> _createSession(User user) async {
    await _sessionBox?.put('currentUserEmail', user.email);
    await _sessionBox?.put('currentUserId', user.id);
    await _sessionBox?.put('loginTime', DateTime.now().toIso8601String());
  }

  /// Find user by email (case-insensitive)
  static User? _findUserByEmail(String email) {
    try {
      final userMap = _usersBox?.get(email.toLowerCase());
      if (userMap == null) return null;
      return User.fromMap(Map<String, dynamic>.from(userMap as Map));
    } catch (e) {
      return null;
    }
  }
}

