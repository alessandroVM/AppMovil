import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart';
import 'package:app_movil/models/product_model.dart';


class BuscarRegistroScreen extends StatefulWidget {
  const BuscarRegistroScreen({super.key});

  @override
  State<BuscarRegistroScreen> createState() => _BuscarRegistroScreenState();
}

class _BuscarRegistroScreenState extends State<BuscarRegistroScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialLoad = true;
  String _currentQuery = ''; // Variable adicional para almacenar la consulta actual

  @override
  void initState() {
    super.initState();
    final productController = Provider.of<ProductController>(context, listen: false);
    if (productController.products.isEmpty) {
      productController.loadProducts().then((_) {
        if (mounted) setState(() => _isInitialLoad = false);
      });
    } else {
      _isInitialLoad = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar por nombre, código o QR...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _currentQuery = ''; // Limpiar la consulta actual
                productController.limpiarBusqueda();
              },
            ),
          ),
          onChanged: (query) {
            _currentQuery = query; // Actualizar la consulta actual
            productController.buscarProductos(query);
          },
        ),
      ),
      body: _buildBody(productController),
    );
  }

  Widget _buildBody(ProductController controller) {
    if (_isInitialLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.resultadosBusqueda.isEmpty) {
      return Center(
        child: Text(
          _currentQuery.isEmpty // Usamos _currentQuery en lugar de _searchController.text
              ? 'Ingrese un término de búsqueda'
              : 'No se encontraron resultados',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.resultadosBusqueda.length,
      itemBuilder: (ctx, index) => _buildProductItem(controller.resultadosBusqueda[index]),
    );
  }

  Widget _buildProductItem(Producto producto) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(producto.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${producto.codigo}'),
            Text('Cantidad: ${producto.cantidad}'),
            if (producto.codigoQR != null) Text('QR: ${producto.codigoQR}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navegar a pantalla de detalle si es necesario
          // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: producto)));
        },
      ),
    );
  }
}