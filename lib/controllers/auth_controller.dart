import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_movil/core/services/api_service.dart';


class AuthController with ChangeNotifier {
  final ApiService _apiService;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController(this._apiService);

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Inicializar controlador (llamar en main.dart)
  Future<void> initialize() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _apiService.login(email, password);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String nombre,
    required String rol,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarioData = {
        'nombre': nombre,
        'email': email,
        'rol': rol,
      };

      _user = await _apiService.registrarUsuario(
        usuarioData: usuarioData,
        password: password,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
