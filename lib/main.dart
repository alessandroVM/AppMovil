import 'package:app_movil/controllers/product_controller.dart'; // Importación añadida
import 'package:app_movil/controllers/usuario_controller.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/auth_wrapper.dart';
import 'package:app_movil/views/screens/producto/escaneo_qr_screen.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/login_screen.dart';
import 'package:app_movil/views/screens/producto/menu_screen.dart';
import 'package:app_movil/views/screens/producto/registro_usuario_screen.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/reportes_screen.dart'; // Importación añadida
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/auth_controller.dart';
import 'package:app_movil/core/services/api_service.dart';
import 'package:app_movil/views/screens/producto/buscar_registro_screen.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/registrar_producto_screen.dart';

import 'package:firebase_core/firebase_core.dart'; // Firebase
import 'firebase_options.dart'; // Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final apiService = ApiService();


  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        ChangeNotifierProvider(
          create: (_) => AuthController(apiService)..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductController(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => UsuarioController(apiService), // Pasar apiService aquí
        ),
        //ChangeNotifierProvider(create: (_) => BuscarRegistroController()),
        // Agrega más controladores aquí
      ],
      child: const InventarioCanviaApp(),
    ),
  );
}

class InventarioCanviaApp extends StatelessWidget {
  const InventarioCanviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Canvia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/registro-usuario': (context) => RegistroUsuarioScreen(),
        '/menu': (_) => MenuScreen(),
        '/buscar': (_) => BuscarRegistroScreen(),
        '/registrar': (_) => RegistrarProductoScreen(),
        '/escaneo': (_) => EscaneoQrScreen(),
        '/reportes': (_) => ReportesScreen(),
        // Agrega más rutas

        //   '/': (context) => const BuscarRegistroScreen(),
        //   '/registrar': (context) => const RegistrarProductoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


class PantallaConTitulo extends StatelessWidget {
  final Widget child;
  const PantallaConTitulo({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Controlador de Inventario',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}