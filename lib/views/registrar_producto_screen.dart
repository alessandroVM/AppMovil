import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/registrar_producto_controller.dart';

class RegistrarProductoScreen extends StatefulWidget {
  const RegistrarProductoScreen({super.key});

  @override
  State<RegistrarProductoScreen> createState() => _RegistrarProductoScreenState();
}

class _RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _categoriaController = TextEditingController(text: 'General');

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RegistrarProductoController>(context);

    return Scaffold(
      // ... (mismo código de Scaffold que antes)
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ... (otros campos)
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await controller.registrarProducto(
                      nombre: _nombreController.text,
                      cantidad: int.parse(_cantidadController.text),
                      categoria: _categoriaController.text,
                    );

                    if (mounted) { // Ahora mounted está disponible
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('GUARDAR PRODUCTO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}