import 'package:flutter/material.dart';
// import 'package:app_movil/views/screens/producto/buscar_registro_screen.dart';
// import 'package:app_movil/views/screens/producto/registrar_producto_screen.dart';
// import 'package:app_movil/views/screens/producto/escaneo_qr_screen.dart';
import 'package:provider/provider.dart'; // Necesario para usar Provider
import 'package:app_movil/controllers/auth_controller.dart'; // Para acceder al logout

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Bloqueamos el pop automático
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MENÚ PRINCIPAL'),
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app), // Ícono de logout en posición izquierda
            onPressed: () async {
              final auth = Provider.of<AuthController>(context, listen: false);
              await auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          // Se eliminó el actions[] ya que movimos el logout a leading
        ),
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