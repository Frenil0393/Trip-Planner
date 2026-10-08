import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/data/local_db/db_helper.dart';
import 'package:trip_planner/data/models/user_model.dart';
import 'package:trip_planner/providers/auth_provider.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel instantiation and initials calculation', () {
      final user = UserModel(
        id: 'u-1',
        name: 'Alex Morgan',
        email: 'alex@example.com',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(user.initials, 'AM');

      final singleName = user.copyWith(name: 'Cher');
      expect(singleName.initials, 'C');
    });

    test('UserModel serialization round-trip', () {
      final original = UserModel(
        id: 'u-99',
        name: 'Sarah Connor',
        email: 'sarah@resistance.com',
        avatarUrl: 'https://example.com/sarah.jpg',
        createdAt: DateTime(2026, 5, 20),
      );

      final map = original.toMap();
      final restored = UserModel.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.email, original.email);
      expect(restored.avatarUrl, original.avatarUrl);
    });
  });

  group('AuthProvider Tests', () {
    late AuthProvider auth;

    setUp(() async {
      DatabaseHelper.customDatabasePath = inMemoryDatabasePath;
      await DatabaseHelper.instance.close();
      auth = AuthProvider();
    });

    test('Initial state is unauthenticated', () {
      expect(auth.isAuthenticated, false);
      expect(auth.currentUser, null);
    });

    test('Validation rejects invalid sign up input', () async {
      // Empty name
      var success = await auth.signUp(name: '', email: 'test@mail.com', password: 'password123');
      expect(success, false);
      expect(auth.errorMessage, isNotNull);

      // Invalid email
      success = await auth.signUp(name: 'Bob', email: 'invalid-email', password: 'password123');
      expect(success, false);

      // Short password
      success = await auth.signUp(name: 'Bob', email: 'bob@example.com', password: '123');
      expect(success, false);
    });

    test('Sign up and sign in lifecycle', () async {
      final email = 'john.doe@travel.com';
      final pass = 'securePass123';

      // 1. Sign Up
      final signupSuccess = await auth.signUp(
        name: 'John Doe',
        email: email,
        password: pass,
      );
      expect(signupSuccess, true);
      expect(auth.isAuthenticated, true);
      expect(auth.currentUser?.name, 'John Doe');
      expect(auth.currentUser?.email, email);

      // 2. Duplicate registration fails
      final duplicate = await auth.signUp(
        name: 'John Clone',
        email: email,
        password: 'anotherPassword',
      );
      expect(duplicate, false);

      // 3. Sign Out
      auth.signOut();
      expect(auth.isAuthenticated, false);
      expect(auth.currentUser, null);

      // 4. Sign In with wrong password fails
      final wrongPass = await auth.signIn(email: email, password: 'wrongPassword');
      expect(wrongPass, false);
      expect(auth.isAuthenticated, false);

      // 5. Sign In with correct password succeeds
      final correctPass = await auth.signIn(email: email, password: pass);
      expect(correctPass, true);
      expect(auth.isAuthenticated, true);
      expect(auth.currentUser?.name, 'John Doe');
    });

    test('Password reset allows sign in with new password', () async {
      final email = 'reset.user@example.com';
      await auth.signUp(name: 'Reset User', email: email, password: 'oldPassword123');
      auth.signOut();

      // Reset password
      final resetSuccess = await auth.resetPassword(email: email, newPassword: 'brandNewPassword!');
      expect(resetSuccess, true);

      // Old password no longer works
      final oldAttempt = await auth.signIn(email: email, password: 'oldPassword123');
      expect(oldAttempt, false);

      // New password works
      final newAttempt = await auth.signIn(email: email, password: 'brandNewPassword!');
      expect(newAttempt, true);
      expect(auth.currentUser?.email, email);
    });
  });
}
