import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/models/product_model.dart';
import 'editar_producto_screen.dart';


class DetalleProductoScreen extends StatefulWidget {
  final Producto producto;

  const DetalleProductoScreen({super.key, required this.producto});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nombre:', widget.producto.nombre),
            _buildInfoRow('Código:', widget.producto.codigo),
            _buildInfoRow('Categoría:', widget.producto.categoria),
            _buildInfoRow('Serie:', widget.producto.serie),
            _buildInfoRow('Estatus:', widget.producto.estatus),
            _buildInfoRow('Cantidad:', widget.producto.cantidad.toString()),
            _buildInfoRow('Código QR:', widget.producto.codigoQR),
            _buildInfoRow(
              'Fecha Registro:',
              '${widget.producto.fechaRegistro.day}/'
                  '${widget.producto.fechaRegistro.month}/'
                  '${widget.producto.fechaRegistro.year}',
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'No especificado',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final productController = Provider.of<ProductController>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditarProductoScreen(producto: widget.producto),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Editar', style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () async {
            final confirmar = await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirmar'),
                content: const Text('¿Estás seguro de eliminar este producto?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (confirmar == true) {
              try {
                await productController.eliminarProducto(widget.producto.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto eliminado correctamente')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
                  );
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Eliminar', style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }



}