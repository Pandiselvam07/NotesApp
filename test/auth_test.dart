import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pratice/services/auth/Auth_user.dart';
import 'package:pratice/services/auth/Auth_provider.dart';
import 'package:pratice/services/auth/Auth_exceptions.dart';

void main() {
  group(
    "Mock Authentication",
    () {
      final provider = MockAuthProvider();
      test(
        "Should not be initialized to begin with",
        () {
          expect(provider.isInitialized, false);
        },
      );
      test(
        "Cannot logout  if not initialized",
        () {
          expect(
            provider.logOut(),
            throwsA(const TypeMatcher<NotInitializedAuthException>()),
          );
        },
      );
      test(
        "Should be able to be initialized",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
      );
      test(
        "User should not null after initialization",
        () {
          expect(provider.currentUser, null);
        },
      );
      test(
        "Should be able to be initialize in less than 2 seconds",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(Duration(seconds: 2)),
      );
      test(
        'Create user to delegate to logIn function',
        () async {
          final badEmailuser = provider.createUser(
            email: "pak@war.com",
            password: "anypassword",
          );
          expect(
            badEmailuser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()),
          );
          final badPasswordUser = provider.createUser(
            email: "someone@war.com",
            password: "pakwar777",
          );
          expect(
            badPasswordUser,
            throwsA(const TypeMatcher<WrongPasswordAuthException>()),
          );
          final user = await provider.createUser(
            email: "pak",
            password: "war",
          );
          expect(provider.currentUser, user);
          expect(user.isEmailVerified, false);
        },
      );
      test(
        "Logged in user should be able to verify email",
        () {
          provider.sendEmailVerification();
          final user = provider.currentUser;
          expect(user, isNotNull);
          expect(user!.isEmailVerified, true);
        },
      );
      test(
        "Should be able to log out and log in",
        () async {
          await provider.logOut();
          await provider.logIn(
            email: "email",
            password: "password",
          );
          final user = provider.currentUser;
          expect(user, isNotNull);
        },
      );
    },
  );
}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedAuthException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedAuthException();
    if (email == 'pak@war.com') throw UserNotFoundAuthException();
    if (password == 'pakwar') throw WeakPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'pak@war.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedAuthException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedAuthException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException;
    const newUser = AuthUser(isEmailVerified: true, email: 'pak@war.com');
    _user = newUser;
  }
}
