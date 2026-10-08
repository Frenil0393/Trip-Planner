import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local_db/db_helper.dart';
import '../data/models/user_model.dart';

/// Provider managing authentication state, user sessions, login, and registration.
class AuthProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    restoreSession();
  }

  /// Automatically restores active session from SQLite/Web Storage on app launch.
  Future<void> restoreSession() async {
    try {
      final activeUserId = await _dbHelper.getActiveSession();
      if (activeUserId != null && activeUserId.isNotEmpty) {
        final user = await _dbHelper.getUserById(activeUserId);
        if (user != null) {
          _currentUser = user;
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  /// Clears current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Authenticates a user with email and password.
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter both email and password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final user = await _dbHelper.authenticateUser(cleanEmail, password);
      if (user != null) {
        _currentUser = user;
        await _dbHelper.saveActiveSession(user.id);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred during sign-in.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Registers a new user account and logs them in.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanName = name.trim();
    final cleanEmail = email.trim();

    if (cleanName.isEmpty) {
      _errorMessage = 'Please enter your name.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (cleanEmail.isEmpty || !cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      _errorMessage = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters long.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final newUser = UserModel(
        id: _uuid.v4(),
        name: cleanName,
        email: cleanEmail,
        createdAt: DateTime.now(),
      );

      final success = await _dbHelper.registerUser(newUser, password);
      if (success) {
        _currentUser = newUser;
        await _dbHelper.saveActiveSession(newUser.id);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'An account with this email already exists.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during registration. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logs the user out of the application and clears the session.
  Future<void> signOut() async {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
    try {
      await _dbHelper.clearActiveSession();
    } catch (_) {}
  }

  /// Resets password for a given email address.
  Future<bool> resetPassword({required String email, required String newPassword}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanEmail = email.trim();
    final success = await _dbHelper.resetPassword(cleanEmail, newPassword);

    _isLoading = false;
    if (!success) {
      _errorMessage = 'No account found with this email address.';
    }
    notifyListeners();
    return success;
  }
}
