import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase
import 'package:http/http.dart' as http;
import 'package:app_movil/models/product_model.dart';
import 'package:app_movil/models/usuario_model.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========== PRODUCTOS ==========

  Future<List<Producto>> getProductsFromApi() async {
    try {
      final querySnapshot = await _firestore.collection('productos').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Asegura que los datos tengan el formato correcto
        final productoData = {
          'id': doc.id,
          'codigo': data['codigo'] ?? '',
          'nombre': data['nombre'] ?? '',
          'categoria': data['categoria'] ?? '',
          'serie': data['serie'] ?? '',
          'estatus': data['estatus'] ?? 'Activo',
          'cantidad': data['cantidad'],
          'codigoQR': data['codigoQR'] ?? '',
          'fechaRegistro': data['fechaRegistro'] ?? DateTime.now().toIso8601String(),
        };
        return Producto.fromJson(productoData);
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }

  Future<Producto> registrarProducto(Map<String, dynamic> productoData) async {
    try {
      final docRef = await _firestore.collection('productos').add(productoData);
      final doc = await docRef.get();
      return Producto.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Error al registrar producto: $e');
    }
  }

  Future<Producto> actualizarProducto(String id, Map<String, dynamic> nuevosDatos) async {
    try {
      await _firestore.collection('productos').doc(id).update(nuevosDatos);
      final doc = await _firestore.collection('productos').doc(id).get();
      return Producto.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  Future<void> eliminarProducto(String id) async {
    try {
      await _firestore.collection('productos').doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }

  Future<Producto?> getProductByQR(String codigoQR) async {
    try {
      final snapshot = await _firestore
          .collection('productos')
          .where('codigoQR', isEqualTo: codigoQR)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return Producto.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw Exception('Error al buscar producto por QR: $e');
    }
  }

  Future<List<Producto>> buscarProductos(String query) async {
    try {
      if (query.isEmpty) return [];

      final querySnapshot = await _firestore.collection('productos')
          .where('nombre', isGreaterThanOrEqualTo: query)
          .where('nombre', isLessThan: query + 'z')
          .get();

      return querySnapshot.docs.map((doc) {
        return Producto.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      throw Exception("Error al buscar productos: $e");
    }
  }

  // ========== AUTENTICACIÓN ==========

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<User?> registrarUsuario({
    required Map<String, dynamic> usuarioData,
    required String password,
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: usuarioData['email'],
        password: password,
      );

      // 2. Guardar datos adicionales en Firestore
      await _firestore
          .collection('usuarios')
          .doc(userCredential.user?.uid)
          .set(usuarioData);

      return userCredential.user;
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
}