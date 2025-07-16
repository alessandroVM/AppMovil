import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/files.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistrarProductoScreen extends StatefulWidget {
  const RegistrarProductoScreen({super.key});

  @override
  State<RegistrarProductoScreen> createState() => _RegistrarProductoScreenState();
}

class _RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _serieController = TextEditingController();
  final _cantidadController = TextEditingController();

  String _estatus = 'Activo';
  String _categoria = 'Nuevo';
  String? _codigoProducto;
  bool _generandoCodigo = false;
  bool _generarQR = false;

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
    } catch (e) {
      debugPrint('Error generando código: $e');
      if (mounted) {
        setState(() => _codigoProducto = 'COD-ERR');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error generando código. Intente nuevamente.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _generandoCodigo = false);
      }
    }
  }

  Future<void> _submitForm(ProductController controller) async {
    if (_codigoProducto == null || _generandoCodigo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Espere a que se genere el código')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      final productoData = {
        'nombre': _nombreController.text,
        'cantidad': _cantidadController.text,
        'categoria': _categoria,
        'codigo': _codigoProducto,
        'serie': _serieController.text,
        'estatus': _estatus,
      };

      await controller.registrarProducto(productoData);

      if (_generarQR) {
        await _generarYGuardarQR(productoData);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _generarYGuardarQR(Map<String, dynamic> producto) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso denegado para guardar QR')),
        );
        return;
      }

      final qrData = producto['codigo'];

      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: true,
        color: Colors.black,
        emptyColor: Colors.white, // <-- define el color de fondo vacío
      );

      // Renderizar QR a imagen
      final image = await qrPainter.toImage(300);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final buffer = byteData!.buffer.asUint8List();

      // Guardar archivo temporal
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/${producto['codigo']}.png';

      final file = File(path);
      await file.writeAsBytes(buffer);

      // Guardar a galería
      await GallerySaver.saveImage(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR guardado: ${producto['codigo']}')),
        );
      }
    } catch (e) {
      debugPrint('Error generando QR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al generar el QR')),
      );
    }
  }


  @override
  void dispose() {
    _nombreController.dispose();
    _serieController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductController>(context);

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
                    else
                      Text(
                        _codigoProducto!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _serieController,
                decoration: const InputDecoration(
                  labelText: 'Serie del Producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

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

              DropdownButtonFormField<String>(
                value: _estatus,
                items: ['Activo', 'Baja', 'Custodia', 'Fuera de Garantía']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _estatus = value!),
                decoration: const InputDecoration(
                  labelText: 'Estatus del Producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: _categoria,
                items: ['Fallado', 'Mantenimiento', 'No Operativo', 'Nuevo', 'Operativo', 'Siniestro', 'Prestamo', 'Venta']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _categoria = value!),
                decoration: const InputDecoration(
                  labelText: 'Situación del equipo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              CheckboxListTile(
                title: const Text('Generar y guardar código QR del producto'),
                value: _generarQR,
                onChanged: (value) {
                  setState(() {
                    _generarQR = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () => _submitForm(controller),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('GUARDAR', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
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
