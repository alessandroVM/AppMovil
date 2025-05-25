import 'package:flutter/material.dart';
import 'package:app_movil/models/product_model.dart'; //import '../models/product_model.dart';
import 'package:app_movil/core/services/api_service.dart'; // Importa ApiService

class ProductController with ChangeNotifier {
  List<Producto> _products = [];
  final ApiService _apiService = ApiService();
  Producto? _productoEscaneado; // Nuevo: Para guardar el producto encontrado
  bool _isLoadingScan = false;  // Nuevo: Estado de carga para escaneos

  // Getters existentes
  List<Producto> get products => _products;

  // Nuevos getters para el escaneo
  Producto? get productoEscaneado => _productoEscaneado;
  bool get isLoadingScan => _isLoadingScan;

  // Método existente (se mantiene igual)
  Future<void> loadProducts() async {
    _products = await _apiService.getProductsFromApi();
    notifyListeners();
  }

  // --- NUEVOS MÉTODOS PARA ESCANEO QR ---

  Future<void> buscarProductoPorQR(String codigoQR) async {
    _isLoadingScan = true;
    _productoEscaneado = null; // Limpiar resultado anterior
    notifyListeners();

    try {
      // 1. Primero busca en los productos ya cargados
      _productoEscaneado = _products.firstWhere(
            (p) => p.codigoQR == codigoQR,
        orElse: () => null as Producto, // Evita error si no encuentra
      );

      // 2. Si no está en la lista local, busca en la API
      if (_productoEscaneado == null) {
        final producto = await _apiService.getProductByQR(codigoQR);
        if (producto != null) {
          _productoEscaneado = producto;
          _products.add(producto); // Opcional: agregar a la lista local
        }
      }

    } catch (e) {
      _productoEscaneado = null;
      rethrow; // Permite manejar el error en la pantalla
    } finally {
      _isLoadingScan = false;
      notifyListeners();
    }
  }

  // Método auxiliar para limpiar el resultado del escaneo
  void limpiarEscaneo() {
    _productoEscaneado = null;
    notifyListeners();
  }
}
