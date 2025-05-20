import 'package:flutter/material.dart';
import 'package:app_movil/models/product_model.dart';
import 'package:app_movil/core/services/api_service.dart';

class RegistrarProductoController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> registrarProducto({
    required String nombre,
    required int cantidad,
    required String categoria, // Añade este parámetro
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevoProducto = Producto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        categoria: categoria, // Usa el parámetro recibido
        cantidad: cantidad,
        codigoQR: 'QR-${DateTime.now().millisecondsSinceEpoch}',
        fechaRegistro: DateTime.now(),
      );

      await _apiService.registrarProducto(nuevoProducto.toJson());
    } catch (e) {
      throw Exception('Error al registrar: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}