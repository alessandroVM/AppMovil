import 'package:app_movil/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart'; // Asegúrate de importar tu controlador

//import 'package:flutter_charts/flutter_charts.dart'; // as charts;

import 'package:pie_chart/pie_chart.dart';

/*
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
                  _buildInfoRow('Productos mantenimiento:',
                      '${products.where((p) => p.estatus == 'Mantenimiento').length}'),
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
*/
/////////////////

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    final products = productController.products;

    // 1. Distribución por categorías (ordenado)
    final categoriasCount = _getCategoriasCount(products);
    final categoriasSorted = categoriasCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 2. Distribución por estatus
    final estatusCount = _getEstatusCount(products);
    final estatusSorted = estatusCount.entries.toList();

    // 3. Productos con stock crítico (<5 unidades)
    final productosStockCritico = products.where((p) => p.cantidad < 5).toList();

    // 4. Productos con exceso de stock (>10 unidades)
    final productosExcesoStock = products.where((p) => p.cantidad > 10).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('REPORTES DE INVENTARIO'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
            children: [

              // Sección 1: Distribución por categorías
            _buildCard(
            title: 'Distribución por Categoría',
            child: Column(
              children: [
              SizedBox(
              height: 250,
              child: _buildPieChart(context, categoriasSorted, products.length),
            ),
            const SizedBox(height: 10),
            ...categoriasSorted.map((entry) => _buildCategoryRow(
        entry.key,
        entry.value,
        products.length,
        _getCategoryColor(entry.key),
      )), //////
      ],
    ),
    ),

    const SizedBox(height: 20),

    // Sección 2: Distribución por estatus
    _buildCard(
    title: 'Distribución por Estatus',
    child: Column(
    children: [
    SizedBox(
    height: 250,
    child: _buildPieChart(context, estatusSorted, products.length),
    ),
    const SizedBox(height: 10),
    ...estatusSorted.map((entry) => _buildCategoryRow(
    entry.key,
    entry.value,
    products.length,
    _getEstatusColor(entry.key),
    )), ///////
    ],
    ),
    ),

    const SizedBox(height: 20),

    // Sección 3: Productos con stock crítico
    _buildCard(
    title: 'Productos con Stock Crítico (menos de 5 unidades)',
    subtitle: 'Total: ${productosStockCritico.length}',
    child: Column(
    children: [
    if (productosStockCritico.isEmpty)
    const Text('No hay productos con stock crítico',
    style: TextStyle(color: Colors.grey))
    else
    ...productosStockCritico.map((product) => _buildProductItem(
    product,
    Colors.red[100]!,
    )),
    ],
    ),
    ),

    const SizedBox(height: 20),

    // Sección 4: Productos con exceso de stock
    _buildCard(
    title: 'Productos con Exceso de Stock (más de 10 unidades)',
    subtitle: 'Total: ${productosExcesoStock.length}',
    child: Column(
    children: [
    if (productosExcesoStock.isEmpty)
    const Text('No hay productos con exceso de stock',
    style: TextStyle(color: Colors.grey))
    else
    ...productosExcesoStock.map((product) => _buildProductItem(
    product,
    Colors.green[100]!,
    )),
    ],
    ),
    ),
    ],
    ),
    ),
    );
  }

  Widget _buildPieChart(BuildContext context, List<MapEntry<String, int>> data, int total) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No hay datos disponibles'),
      );
    }

    final Map<String, double> dataMap = {
      for (var entry in data)
        entry.key: entry.value.toDouble()
    };

    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      legendOptions: const LegendOptions(
        showLegends: true,
        legendPosition: LegendPosition.bottom,
        legendTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
        chartValueStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Texto en negro
        ),
      ),
      colorList: data.map((entry) =>
      entry.key == 'Activo' ? _getEstatusColor(entry.key) :
      entry.key == 'Inactivo' ? _getEstatusColor(entry.key) :
      _getCategoryColor(entry.key)
      ).toList(),
      animationDuration: Duration.zero, // const Duration(milliseconds: 800),
    );
  }

  // Métodos auxiliares
  Map<String, int> _getCategoriasCount(List<Producto> products) {
    final Map<String, int> count = {};
    for (var product in products) {
      count.update(
        product.categoria,
            (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return count;
  }

  Map<String, int> _getEstatusCount(List<Producto> products) {
    final Map<String, int> count = {};
    for (var product in products) {
      count.update(
        product.estatus,
            (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return count;
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
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
            if (subtitle != null) Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, int count, int total, Color color) {
    final percentage = (count / total * 100).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(category),
          ),
          Expanded(
            flex: 2,
            child: Text('$count productos'),
          ),
          Expanded(
            flex: 2,
            child: Text('$percentage%'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Producto product, Color chipColor) {
    return ListTile(
      title: Text(product.nombre),
      subtitle: Text('Código: ${product.codigo} • ${product.categoria}'),
      trailing: Chip(
        label: Text('${product.cantidad}'),
        backgroundColor: chipColor,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Construcción': Colors.yellow,
      'Electrónica': Colors.blue,
      'General': Colors.green,
      'Herramientas': Colors.purple,
      'Materiales': Colors.brown,
    };
    return colors[category] ?? Colors.grey;
  }

  Color _getEstatusColor(String estatus) {
    final colors = {
      'Activo': Colors.green,
      'Inactivo': Colors.red,
      'Mantenimiento': Colors.yellow,
    };
    return colors[estatus] ?? Colors.grey;
  }
}
