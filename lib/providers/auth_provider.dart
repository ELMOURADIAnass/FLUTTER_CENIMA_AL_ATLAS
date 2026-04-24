import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_repository.dart';

/// Provider for managing authentication state and operations
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  /// Initialize auth provider - check for existing session
  Future<void> initialize() async {
    _currentUser = AuthRepository.getCurrentUser();
    notifyListeners();
  }

  /// Register a new user
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (success, message) = await AuthRepository.register(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (success) {
        _currentUser = AuthRepository.getCurrentUser();
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (success, message) = await AuthRepository.login(
        email: email,
        password: password,
      );

      if (success) {
        _currentUser = AuthRepository.getCurrentUser();
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await AuthRepository.logout();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({required String fullName}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (success, message) = await AuthRepository.updateProfile(
        fullName: fullName,
      );

      if (success) {
        _currentUser = AuthRepository.getCurrentUser();
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Update failed: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Change user password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (success, message) = await AuthRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Password change failed: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

