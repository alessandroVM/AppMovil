import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/usuario_controller.dart';
import 'package:app_movil/models/usuario_model.dart';
import 'package:app_movil/views/screens/producto/login_screen.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({super.key});

  @override
  State<RegistroUsuarioScreen> createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _rolSeleccionado = 'empleado'; // Valor por defecto

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      final nuevoUsuario = Usuario(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        email: _emailController.text,
        rol: _rolSeleccionado,
      );

      try {
        final controller = Provider.of<UsuarioController>(context, listen: false);
        await controller.registrarUsuario(
          usuario: nuevoUsuario,
          password: _passwordController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario registrado exitosamente')),
          );

          // Navegación de regreso al login con reemplazo
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );

          // Opcional: Limpiar los campos antes de volver
          _nombreController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Usuario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  if (!value.contains('@')) {
                    return 'Ingrese un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _rolSeleccionado,
                items: const [
                  DropdownMenuItem(
                    value: 'empleado',
                    child: Text('Empleado'),
                  ),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Administrador'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _rolSeleccionado = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Rol del Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Registrar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}