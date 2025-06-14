import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_movil/core/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_movil/models/usuario_model.dart';
import 'package:app_movil/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor
  AuthController(ApiService apiService);

  User? get user => _auth.currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  // Método para inicializar el controlador
  Future<void> initialize() async {
    // Puedes agregar lógica de inicialización si es necesario
    notifyListeners();
  }


  Future<void> login(String email, String password, BuildContext context) async {
  try {
    _isLoading = true;
    notifyListeners();

    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Cargar productos después del login exitoso
    final productController = Provider.of<ProductController>(context, listen: false);
    await productController.loadProducts();

    _errorMessage = null;
  } on FirebaseAuthException catch (e) {
    _errorMessage = _getErrorMessage(e);
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> register({
    required String email,
    required String password,
    required String nombre,
    required String rol,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 1. Registrar usuario en Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Guardar información adicional en Firestore
      final nuevoUsuario = Usuario(
        id: userCredential.user!.uid,
        nombre: nombre,
        email: email,
        rol: rol,
      );

      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set(nuevoUsuario.toJson());

      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      rethrow;
    } catch (e) {
      _errorMessage = 'Error al registrar usuario: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'El email ya está en uso';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-email':
        return 'Email inválido';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      default:
        return 'Error desconocido: ${e.message}';
    }
  }
}