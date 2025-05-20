import 'package:flutter/material.dart';
import 'package:app_movil/models/product_model.dart'; //import '../models/product_model.dart';
import 'package:app_movil/core/services/api_service.dart'; // Importa ApiService

class ProductController with ChangeNotifier {
  List<Producto> _products = [];
  final ApiService _apiService = ApiService(); // Instancia el servicio

  List<Producto> get products => _products;

  Future<void> loadProducts() async {
    _products = await _apiService.getProductsFromApi(); // Usa la instancia
    notifyListeners();
  }
}