import 'package:flutter/material.dart';
import 'package:app_movil/models/usuario_model.dart';
import 'package:app_movil/core/services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioController with ChangeNotifier {
  final ApiService _apiService;
  bool _isLoading = false;
  String? _errorMessage;

  UsuarioController(this._apiService); // Inyectamos ApiService

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> registrarUsuario({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Registrar usuario usando ApiService (que ahora usa Firebase)
      await _apiService.registrarUsuario(
        usuarioData: {
          'nombre': nombre,
          'email': email,
          'rol': rol,
        },
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

  // Método adicional para obtener usuarios
  Stream<List<Usuario>> obtenerUsuarios() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Usuario.fromJson(doc.data()))
        .toList());
  }
}