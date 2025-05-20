import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/controllers/product_controller.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Inventario Canvia")),
      body: ListView.builder(
        itemCount: controller.products.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(controller.products[index].nombre),
          subtitle: Text("Cantidad: ${controller.products[index].cantidad}"),
        ),
      ),
    );
  }
}