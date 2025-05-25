import 'package:flutter/material.dart';
import 'package:app_movil/views/screens/producto/menu_screen.dart';
import 'package:app_movil/views/screens/producto/registro_usuario_screen.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'CONTROL DE INVENTARIO',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 40),

            // Campo de email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de contraseña
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Botón de Ingresar
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MenuScreen()),
              ),
              child: const Text('INGRESAR'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),

            // Botón de Registro (NUEVO)
            TextButton(
              onPressed: () {
                // Navegación a la pantalla de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroUsuarioScreen(),
                  ),
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: '¿No tienes cuenta? ',
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: 'Regístrate aquí',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}