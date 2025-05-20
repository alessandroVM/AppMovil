import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movil/models/product_model.dart';

class ApiService {
  final String _baseUrl = "https://api.canvia.com/inventario";
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer tu_token' // Si tu API requiere autenticación
  };

  // Método para búsqueda de productos
  Future<List<Producto>> buscarProductos(String query) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/productos?q=${Uri.encodeQueryComponent(query)}"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
  //Metodo getproducts
  Future<List<Producto>> getProductsFromApi() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/productos"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // Métodos adicionales que podrías necesitar
  Future<List<Producto>> obtenerTodosProductos() async {
    return await buscarProductos(""); // Búsqueda vacía para obtener todos
  }

  Future<void> registrarProducto(Map<String, dynamic> producto) async {
    // Implementación existente...
  }
}