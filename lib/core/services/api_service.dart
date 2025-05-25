import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movil/models/product_model.dart';
import 'package:app_movil/models/usuario_model.dart';

class ApiService {
  final String _baseUrl = "https://api.canvia.com/inventario";
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer tu_token' // Si tu API requiere autenticación
  };

  //Método registrar usuario
  Future<void> registrarUsuario({
    required Map<String, dynamic> usuario,
    required String password,
  }) async {
    final body = {
      ...usuario,
      'password': password,
    };

    final response = await http.post(
      Uri.parse("$_baseUrl/usuarios"),
      headers: _headers,
      body: json.encode(body),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar usuario: ${response.statusCode}');
    }
  }


  // Método para búsqueda de productos
  Future<List<Producto>> buscarProductos(String query) async {
    try {
      final response = await http.get(
        Uri.parse("_baseUrl/productos?q=${Uri.encodeQueryComponent(query)}"), //$_baseUrl
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

  Future<Producto?> getProductByQR(String codigoQR) async {
    try {
      final response = await http.get(
        Uri.parse('_baseUrl/productos?codigoQR=$codigoQR'),  //$_baseUrl
      );

      if (response.statusCode == 200) {
        return Producto.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Error al buscar producto por QR: $e');
    }
  }


}