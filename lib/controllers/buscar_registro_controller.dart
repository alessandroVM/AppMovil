import 'package:flutter/material.dart';
import 'package:app_movil/models/product_model.dart';
import 'package:app_movil/core/services/api_service.dart';

class BuscarRegistroController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Producto> _resultados = [];

  List<Producto> get resultadosBusqueda => _resultados;

  Future<void> buscarProductos(String query) async {
    if (query.isEmpty) {
      _resultados = [];
    } else {
      _resultados = await _apiService.buscarProductos(query);
    }
    notifyListeners();
  }
}