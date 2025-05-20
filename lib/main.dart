import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/buscar_registro_controller.dart';
import 'controllers/registrar_producto_controller.dart';
import 'views/buscar_registro_screen.dart';
import 'views/registrar_producto_screen.dart'; // Importación añadida

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuscarRegistroController()),
        ChangeNotifierProvider(create: (_) => RegistrarProductoController()),
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
      initialRoute: '/',
      routes: {
        '/': (context) => BuscarRegistroScreen(),
        '/registrar': (context) => const RegistrarProductoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}