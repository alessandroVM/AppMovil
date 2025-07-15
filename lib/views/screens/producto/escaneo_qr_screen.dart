import 'package:app_movil/controllers/product_controller.dart';
import 'package:app_movil/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/views/screens/producto/menu_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import '../../controllers/product_controller.dart';

class EscaneoQrScreen extends StatefulWidget {
  const EscaneoQrScreen({super.key});

  @override
  State<EscaneoQrScreen> createState() => _EscaneoQrScreenState();
}


class _EscaneoQrScreenState extends State<EscaneoQrScreen> {
  String _scanResult = 'Presiona el botón para escanear';
  bool _isLoading = false;
  final MobileScannerController _scannerController = MobileScannerController(); // Cambio aquí

  Future<void> _scanQR() async {
    setState(() {
      _isLoading = true;
      _scanResult = 'Escaneando...';
    });

    // No necesitamos iniciar el escaneo manualmente, el widget MobileScanner lo maneja
  }

  Future<void> _buscarProducto(String codigoQR) async {
    final controller = Provider.of<ProductController>(context, listen: false);
    await controller.buscarProductoPorQR(codigoQR);

    if (controller.productoEscaneado != null) {
      if (!mounted) return;
      _mostrarDetalleProducto(context, controller.productoEscaneado!);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto no encontrado')),
      );
    }
  }

  void _mostrarDetalleProducto(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle del Producto'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: producto.codigoQR,
                version: QrVersions.auto,
                size: 100.0,
              ),
              const SizedBox(height: 16),
              Text('Código: ${producto.codigo}'),
              Text('Nombre: ${producto.nombre}'),
              Text('Categoría: ${producto.categoria}'),
              Text('Serie: ${producto.serie}'),
              Text('Cantidad: ${producto.cantidad}'),
              Text('Estado: ${producto.estatus}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose(); // Importante: limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESCANEAR CÓDIGO QR'),
        centerTitle: true,
        /*actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.TorchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => _scannerController.toggleTorch(),
          ),
        ],*/
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    _scanResult = 'Resultado: ${barcode.rawValue}';
                  });
                  _buscarProducto(barcode.rawValue ?? '');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Resultado del escaneo
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.qr_code_scanner, size: 50),
                        const SizedBox(height: 16),
                        Text(
                          _scanResult,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Botón de escaneo
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _scanQR,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.qr_code_scanner),
                  label: Text(_isLoading ? 'Escaneando...' : 'Escanear QR'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





/*
class _EscaneoQrScreenState extends State<EscaneoQrScreen> {
  String _scanResult = 'Presiona el botón para escanear';
  bool _isLoading = false;

  Future<void> _scanQR() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', // Color del scanner
        'Cancelar', // Texto del botón cancelar
        true, // Usar flash
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        _scanResult = barcodeScanResult == '-1'
            ? 'Escaneo cancelado'
            : 'Resultado: $barcodeScanResult';
      });

      if (barcodeScanResult != '-1') {
        _buscarProducto(barcodeScanResult);
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _buscarProducto(String codigoQR) async {
    final controller = Provider.of<ProductController>(context, listen: false);
    await controller.buscarProductoPorQR(codigoQR);

    if (controller.productoEscaneado != null) {
      if (!mounted) return;
      _mostrarDetalleProducto(context, controller.productoEscaneado!);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto no encontrado')),
      );
    }
  }

  void _mostrarDetalleProducto(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle del Producto'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: producto.codigoQR,
                version: QrVersions.auto,
                size: 100.0,
              ),
              const SizedBox(height: 16),
              Text('Código: ${producto.codigo}'),
              Text('Nombre: ${producto.nombre}'),
              Text('Categoría: ${producto.categoria}'),
              Text('Serie: ${producto.serie}'),
              Text('Cantidad: ${producto.cantidad}'),
              Text('Estado: ${producto.estatus}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESCANEAR CÓDIGO QR'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Resultado del escaneo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      _scanResult,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Botón de escaneo
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _scanQR,
              icon: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.qr_code_scanner),
              label: Text(_isLoading ? 'Escaneando...' : 'Escanear QR'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/