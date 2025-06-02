import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart';


class RegistrarProductoScreen extends StatefulWidget {
  const RegistrarProductoScreen({super.key});

  @override
  State<RegistrarProductoScreen> createState() => _RegistrarProductoScreenState();
}

class _RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _serieController = TextEditingController();
  final _cantidadController = TextEditingController();
  String _estatus = 'Activo'; // Valor por defecto
  String _categoria = 'General'; // Valor por defecto

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _serieController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(ProductController controller) async { // ✅ Cambia el tipo
    if (!_formKey.currentState!.validate()) return;

    try {
      await controller.registrarProducto({ // ✅ Usa el método de ProductController
        'nombre': _nombreController.text,
        'cantidad': _cantidadController.text,
        'categoria': _categoria,
        'codigo': _codigoController.text,
        'serie': _serieController.text,
        'estatus': _estatus,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'), // ✅ Muestra el error directo
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductController>(context); // ✅ Cambia aquí

    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTRAR PRODUCTO'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo: Código del Producto (Obligatorio)
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código del Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 15),

              // Campo: Descripción/Nombre (Obligatorio)
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 15),

              // Campo: Serie (Opcional)
              TextFormField(
                controller: _serieController,
                decoration: const InputDecoration(
                  labelText: 'Serie del Producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Campo: Cantidad (Obligatorio y numérico)
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Este campo es obligatorio';
                  if (int.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Dropdown: Estatus (Obligatorio)
              DropdownButtonFormField<String>(
                value: _estatus,
                items: ['Activo', 'Inactivo'].map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
                onChanged: (value) => setState(() => _estatus = value!),
                decoration: const InputDecoration(
                  labelText: 'Estatus del Producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Dropdown: Categoría (Obligatorio)
              DropdownButtonFormField<String>(
                value: _categoria,
                items: ['Construcción', 'Electrónica', 'General'].map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
                onChanged: (value) => setState(() => _categoria = value!),
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
                children: [
                  // Botón GUARDAR
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading ? null : () => _submitForm(controller),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('GUARDAR', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Botón CANCELAR
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('CANCELAR', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}