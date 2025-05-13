import 'package:flutter/foundation.dart';
import 'package:project/models/user.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;
  AppUser? _user;

  AuthProvider(this._authService, this._storageService) {
    // Listen for auth state changes (e.g., auto-login)
    _authService.authStateChanges.listen((user) {
      _isInitializing = false;
      _user = user != null ? AppUser.fromFirebase(user) : null;
      notifyListeners();
    });
  }

  AppUser? get user => _user;

  // ADD THIS METHOD
  Future<void> signUp(String email, String password) async {
    try {
      final firebaseUser = await _authService.signUp(email, password);
      _user = AppUser.fromFirebase(firebaseUser!);
      final token = await firebaseUser.getIdToken();
      await _storageService.saveToken(token!);
      notifyListeners();
    } catch (e) {
      rethrow; // Propagate error to UI for handling
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final firebaseUser = await _authService.signIn(email, password);
      _user = AppUser.fromFirebase(firebaseUser!);
      final token = await firebaseUser.getIdToken();
      await _storageService.saveToken(token!);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await _storageService.deleteToken();
    _user = null;
    notifyListeners();
  }
}