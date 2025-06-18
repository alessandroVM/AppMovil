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
  //final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _serieController = TextEditingController();
  final _cantidadController = TextEditingController();
  String _estatus = 'Activo'; // Valor por defecto
  String _categoria = 'Nuevo'; // Valor por defecto
  //String _codigoProducto = 'Cargando...'; // Cambiamos a String // op1
  //bool _cargandoCodigo = true;                                  // op1
  String? _codigoProducto; // Cambiado a nullable para manejar estado inicial
  bool _cargandoCodigo = false; // Inicialmente no está cargando
  bool _generandoCodigo = false;

  /*@override
  void initState() {
    super.initState();
    _generarCodigo(); // Generar código inmediatamente
  }*/
/*
  Future<void> _generarCodigo() async {
    final controller = Provider.of<ProductController>(context, listen: false);
    try {
      final codigo = await controller.obtenerProximoCodigo();
      if (mounted) {
        setState(() {
          _codigoProducto = codigo;
          _cargandoCodigo = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error generando código: $e');
      debugPrint(stackTrace.toString());
      if (mounted) {
        setState(() {
          _codigoProducto = 'COD-ERR';
          _cargandoCodigo = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generando código. Intente nuevamente.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }*/

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generarCodigo();
    });
  }

  Future<void> _generarCodigo() async {
    if (_generandoCodigo) return;

    setState(() => _generandoCodigo = true);

    final controller = Provider.of<ProductController>(context, listen: false);
    try {
      final codigo = await controller.obtenerProximoCodigo();
      if (mounted) {
        setState(() => _codigoProducto = codigo);
      }
    } catch (e, stackTrace) {
      debugPrint('Error generando código: $e');
      debugPrint(stackTrace.toString());
      if (mounted) {
        setState(() => _codigoProducto = 'COD-ERR');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error generando código. Intente nuevamente.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _generandoCodigo = false);
      }
    }
  }


  @override
  void dispose() {
    //_codigoController.dispose();
    _nombreController.dispose();
    _serieController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }


  Future<void> _submitForm(ProductController controller) async { // ✅ Cambia el tipo

    // ✅ CAMBIO NUEVO: Validar si el código aún no se ha generado
    if (_codigoProducto == null || _generandoCodigo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Espere a que se genere el código'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      // Convertir cantidad a número
      //final cantidad = int.tryParse(_cantidadController.text) ?? 0;

      await controller.registrarProducto({ // ✅ Usa el método de ProductController
        'nombre': _nombreController.text,
        'cantidad': _cantidadController.text,
        'categoria': _categoria,
        //'codigo': _codigoController.text,
        'codigo': _codigoProducto, // Usamos el código autogenerado
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
              // Campo: Código del Producto (Autogenerado)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Text('Código del Producto: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    //_cargandoCodigo           // op1
                    //    ? const SizedBox(     // op1
                    /*if (_codigoProducto == null || _cargandoCodigo)   //op2
                        const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )*/

                    if (_codigoProducto == null)
                      const Expanded(
                        child: Text('Generando código...',
                            style: TextStyle(color: Colors.grey)),
                      )
                    else if (_generandoCodigo)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )

                        //: Text(_codigoProducto,   //op1
                    else                            //op2
                      Text(                         //op2
                          _codigoProducto!,         //op2
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ],
                ),
              ),
              /* TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código del Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),*/
              const SizedBox(height: 20),

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
                items: ['Activo', 'Baja', 'Custodia', 'Fuera de Garantía'].map((e) => DropdownMenuItem(
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
                items: ['Fallado', 'Mantenimiento', 'No Operativo', 'Nuevo', 'Operativo', 'Siniestro', 'Prestamo', 'Venta'].map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
                onChanged: (value) => setState(() => _categoria = value!),
                decoration: const InputDecoration(
                  labelText: 'Situación del equipo',
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