import 'package:app_movil/controllers/product_controller.dart'; // Importación añadida
import 'package:app_movil/controllers/usuario_controller.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/escaneo_qr_screen.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/login_screen.dart';
import 'package:app_movil/views/screens/producto/menu_screen.dart';
import 'package:app_movil/views/screens/producto/registro_usuario_screen.dart'; // Importación añadida
import 'package:app_movil/views/screens/producto/reportes_screen.dart'; // Importación añadida
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/buscar_registro_controller.dart';
import 'controllers/registrar_producto_controller.dart';
import 'views/screens/producto/buscar_registro_screen.dart'; // Importación añadida
import 'views/screens/producto/registrar_producto_screen.dart'; // Importación añadida

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioController()), // Añade esta línea
        ChangeNotifierProvider(create: (_) => BuscarRegistroController()),
        ChangeNotifierProvider(create: (_) => RegistrarProductoController()),
        ChangeNotifierProvider(create: (_) => ProductController()), // Añade esta línea
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
        '/login': (_) => LoginScreen(),
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