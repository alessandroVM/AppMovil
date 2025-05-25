import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../core/services/api_service.dart';

class UsuarioController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> registrarUsuario({
    required Usuario usuario,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Aquí iría la llamada real a tu API
      await _apiService.registrarUsuario(
        usuario: usuario.toJson(),
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}