import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart'; // Asegúrate de importar tu controlador

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    final products = productController.products; // Lista de productos

    // Datos de ejemplo para gráficos (puedes reemplazar con tus datos reales)
    final Map<String, int> categoriasCount = {
      'Construcción': products.where((p) => p.categoria == 'Construcción').length,
      'Electrónica': products.where((p) => p.categoria == 'Electrónica').length,
      'General': products.where((p) => p.categoria == 'General').length,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('REPORTES DE INVENTARIO'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sección 1: Resumen general
            _buildCard(
              title: 'Resumen General',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Total de productos:', '${products.length}'),
                  _buildInfoRow('Productos activos:',
                      '${products.where((p) => p.estatus == 'Activo').length}'),
                  _buildInfoRow('Productos inactivos:',
                      '${products.where((p) => p.estatus == 'Inactivo').length}'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sección 2: Gráfico por categorías (simplificado)
            _buildCard(
              title: 'Distribución por Categoría',
              child: Column(
                children: [
                  for (var entry in categoriasCount.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(entry.key),
                          ),
                          Expanded(
                            flex: 5,
                            child: LinearProgressIndicator(
                              value: products.isEmpty ? 0 : entry.value / products.length,  // entry.value / products.length,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('${entry.value}'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sección 3: Lista de productos con bajo stock
            _buildCard(
              title: 'Productos con Stock Bajo (<5 unidades)',
              child: Column(
                children: [
                  if (products.where((p) => p.cantidad < 5).isEmpty)
                    const Text('No hay productos con stock bajo',
                        style: TextStyle(color: Colors.grey))
                  else
                    for (var product in products.where((p) => p.cantidad < 5))
                      ListTile(
                        title: Text(product.nombre),
                        subtitle: Text('Código: ${product.codigo}'),
                        trailing: Chip(
                          label: Text('${product.cantidad}'),
                          backgroundColor: Colors.red[100],
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para tarjetas
  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para filas de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}