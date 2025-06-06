import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart';
import 'package:app_movil/models/product_model.dart';

class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _codigoController;
  late TextEditingController _categoriaController;
  late TextEditingController _serieController;
  late TextEditingController _cantidadController;
  late TextEditingController _codigoQrController;
  late String _estatus;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto.nombre);
    _codigoController = TextEditingController(text: widget.producto.codigo);
    _categoriaController = TextEditingController(text: widget.producto.categoria);
    _serieController = TextEditingController(text: widget.producto.serie);
    _cantidadController = TextEditingController(text: widget.producto.cantidad.toString());
    _codigoQrController = TextEditingController(text: widget.producto.codigoQR);
    _estatus = widget.producto.estatus;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _categoriaController.dispose();
    _serieController.dispose();
    _cantidadController.dispose();
    _codigoQrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarCambios,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nombreController, 'Nombre', Icons.shopping_bag),
              _buildTextField(_codigoController, 'Código', Icons.code),
              _buildTextField(_categoriaController, 'Categoría', Icons.category),
              _buildTextField(_serieController, 'Serie', Icons.confirmation_number),
              _buildTextField(_cantidadController, 'Cantidad', Icons.format_list_numbered, isNumber: true),
              _buildTextField(_codigoQrController, 'Código QR', Icons.qr_code),

              const SizedBox(height: 16),
              _buildEstatusDropdown(),

              const SizedBox(height: 24),
              _buildGuardarButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEstatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _estatus,
      decoration: InputDecoration(
        labelText: 'Estatus',
        //prefixIcon: const Icon(Icons.status), // EVALUAR
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Activo', child: Text('Activo')),
        DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
        DropdownMenuItem(value: 'Mantenimiento', child: Text('Mantenimiento')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _estatus = value;
          });
        }
      },
    );
  }

  Widget _buildGuardarButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _guardarCambios,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Guardar Cambios',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final productController = Provider.of<ProductController>(context, listen: false);

      final datosActualizados = {
        'nombre': _nombreController.text,
        'codigo': _codigoController.text,
        'categoria': _categoriaController.text,
        'serie': _serieController.text,
        'cantidad': int.tryParse(_cantidadController.text) ?? 0,
        'codigoQR': _codigoQrController.text,
        'estatus': _estatus,
      };

      try {
        await productController.actualizarProducto(widget.producto.id, datosActualizados);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto actualizado correctamente')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
          );
        }
      }
    }
  }
}