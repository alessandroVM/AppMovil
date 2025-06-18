import 'package:app_movil/models/product_model.dart';
import 'package:app_movil/core/services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductController with ChangeNotifier {
  final ApiService _apiService;
  List<Producto> _products = [];
  List<Producto> _resultadosBusqueda = [];
  Producto? _productoEscaneado;
  bool _isLoading = false;
  bool _isLoadingScan = false;
  bool _isSearching = false;

  ProductController(this._apiService);

  // Getters
  List<Producto> get products => _products;
  List<Producto> get resultadosBusqueda => _resultadosBusqueda;
  Producto? get productoEscaneado => _productoEscaneado;
  bool get isLoading => _isLoading;
  bool get isLoadingScan => _isLoadingScan;
  bool get isSearching => _isSearching;

  // ========== OPERACIONES CRUD ==========

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.getProductsFromApi();
    } catch (e) {
      debugPrint('Error cargando productos: $e');
      _products = []; // Asegúrate de limpiar la lista en caso de error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registrarProducto(Map<String, dynamic> productoData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final productoCompleto = {
        ...productoData,
        'codigoQR': productoData['codigoQR'] ?? 'QR-${DateTime.now().millisecondsSinceEpoch}',
        'fechaRegistro': DateTime.now().toIso8601String(),
      };

      final nuevoProducto = await _apiService.registrarProducto(productoCompleto);
      _products.add(nuevoProducto);
    } catch (e) {
      debugPrint('Error registrando producto: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarProducto(String id, Map<String, dynamic> nuevosDatos) async {
    _isLoading = true;
    notifyListeners();

    try {
      final productoActualizado = await _apiService.actualizarProducto(id, nuevosDatos);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = productoActualizado;
      }
    } catch (e) {
      debugPrint('Error actualizando producto: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarProducto(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.eliminarProducto(id);
      _products.removeWhere((p) => p.id == id);
      _resultadosBusqueda.removeWhere((p) => p.id == id);
    } catch (e) {
      debugPrint('Error eliminando producto: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========== BÚSQUEDAS ==========

  Future<void> buscarProductos(String query) async {
    _isSearching = true;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _resultadosBusqueda = [];
        notifyListeners();
        return;
      }

      // Primero buscar localmente
      _resultadosBusqueda = _products.where((producto) {
        final searchTerm = query.toLowerCase();
        return producto.nombre.toLowerCase().contains(searchTerm) ||
            (producto.codigo?.toLowerCase().contains(searchTerm) ?? false) ||
            (producto.codigoQR.toLowerCase().contains(searchTerm)) ||
            (producto.serie?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();

      // Si no hay resultados locales, buscar en Firestore
      if (_resultadosBusqueda.isEmpty) {
        final results = await _apiService.buscarProductos(query);
        _resultadosBusqueda = results;

        // Opcional: agregar los resultados encontrados a la lista local
        //_products.addAll(results.where((p) => !_products.any((existing) => existing.id == p.id))); // ANTERIOR

        // Agrega los nuevos resultados a la lista local //NUEVO
        for (var p in results) {
          if (!_products.any((existing) => existing.id == p.id)) {
            _products.add(p);
          }
        }


      }
    } catch (e) {
      debugPrint('Error buscando productos: $e');
      _resultadosBusqueda = [];
      rethrow;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> buscarProductoPorQR(String codigoQR) async {
    _isLoadingScan = true;
    _productoEscaneado = null;
    notifyListeners();

    try {
      // 1. Buscar en lista local
      _productoEscaneado = _products.firstWhere(
            (p) => p.codigoQR == codigoQR,
        orElse: () => null as Producto,
      );

      // 2. Buscar en API si no se encuentra localmente
      if (_productoEscaneado == null) {
        final producto = await _apiService.getProductByQR(codigoQR);
        if (producto != null) {
          _productoEscaneado = producto;
          _products.add(producto);
        }
      }
    } catch (e) {
      debugPrint('Error buscando producto por QR: $e');
      rethrow;
    } finally {
      _isLoadingScan = false;
      notifyListeners();
    }
  }

  void limpiarBusqueda() {
    _resultadosBusqueda = [];
    notifyListeners();
  }

  void limpiarEscaneo() {
    _productoEscaneado = null;
    notifyListeners();
  }

  // Generador de codigo de producto v1
  /*Future<String> obtenerProximoCodigo() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('contadores').doc('codigos_productos');

      return await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {'ultimoCodigo': 0});
          return 'COD-1';
        }

        final ultimoCodigo = snapshot.data()!['ultimoCodigo'] as int;
        final nuevoCodigo = ultimoCodigo + 1;

        transaction.update(docRef, {'ultimoCodigo': nuevoCodigo});
        return 'COD-$nuevoCodigo';
      });
    } catch (e) {
      debugPrint('Error generando código: $e');
      return 'COD-ERR'; // Valor de respaldo
    }
  }*/

  // Generador de codigo de producto v2
  /*Future<String> obtenerProximoCodigo() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('contadores').doc('codigos_productos');

      // Agrega logs para depuración
      debugPrint('Iniciando generación de código...');

      final result = await FirebaseFirestore.instance.runTransaction<String>((transaction) async {
        final snapshot = await transaction.get(docRef);
        debugPrint('Snapshot obtenido: ${snapshot.exists}');

        if (!snapshot.exists) {
          debugPrint('Creando documento de contador por primera vez');
          transaction.set(docRef, {'ultimoCodigo': 0});
          return 'COD-1';
        }

        final ultimoCodigo = snapshot.data()?['ultimoCodigo'] ?? 0;
        final nuevoCodigo = (ultimoCodigo as int) + 1;

        debugPrint('Actualizando contador a $nuevoCodigo');
        transaction.update(docRef, {'ultimoCodigo': nuevoCodigo});
        return 'COD-$nuevoCodigo';
      });

      debugPrint('Código generado con éxito: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('Error crítico en obtenerProximoCodigo: $e');
      debugPrint(stackTrace.toString());
      return 'COD-ERR';
    }
  }*/


  // Generador de codigo de producto v3
  Future<String> obtenerProximoCodigo() async {
    try {
      // Obtener el producto con el código más alto ordenando desc
      final querySnapshot = await FirebaseFirestore //new  //_firestore //old
          .instance //new
          .collection('productos')
          .orderBy('codigo', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // No hay productos registrados, retornar COD-1
        return 'COD-1';
      }

      final ultimoCodigo = querySnapshot.docs.first.get('codigo') as String;

      // Asumiendo formato 'COD-X'
      final parts = ultimoCodigo.split('-');
      if (parts.length != 2) {
        // Si formato inesperado, empezar desde 1
        return 'COD-1';
      }

      final numero = int.tryParse(parts[1]) ?? 0;

      // Incrementar
      final nuevoNumero = numero + 1;

      return 'COD-$nuevoNumero';
    } catch (e) {
      debugPrint('Error obteniendo próximo código: $e'); //print o debugPrint
      return 'COD-1'; // fallback para evitar crash
    }
  }







}