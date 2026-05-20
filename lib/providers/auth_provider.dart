import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  
  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  
  User? _currentUser;
  User? get currentUser => _currentUser;
  String? get uid => _currentUser?.uid;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription? _userSub;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      notifyListeners();
      
      if (user != null) {
        _listenToUserProfile(user.uid);
      } else {
        _userSub?.cancel();
        _userModel = null;
        notifyListeners();
      }
    });
  }

  void _listenToUserProfile(String uid) {
    _userSub?.cancel();
    _userSub = _userService.getUserProfile(uid).listen((model) {
      _userModel = model;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmailPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.registerWithEmailPassword(name, email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> updateProfileImage(String uid, String imagePath) async {
    _isLoading = true;
    notifyListeners();
    try {
      final imageFile = File(imagePath);
      await _userService.uploadProfileImage(uid, imageFile);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
