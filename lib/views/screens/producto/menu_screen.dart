import 'package:flutter/material.dart';
import 'package:app_movil/views/screens/producto/buscar_registro_screen.dart';
import 'package:app_movil/views/screens/producto/registrar_producto_screen.dart';
import 'package:app_movil/views/screens/producto/escaneo_qr_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('MENÚ PRINCIPAL')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        children: [
          _buildMenuButton(context, 'REGISTRAR PRODUCTO', Icons.add, '/registrar'),
          _buildMenuButton(context, 'BUSCAR PRODUCTO', Icons.search, '/buscar'),
          _buildMenuButton(context, 'ESCANEAR QR', Icons.qr_code, '/escaneo'),
          _buildMenuButton(context, 'REPORTES', Icons.assessment, '/reportes'),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}