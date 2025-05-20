import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/buscar_registro_controller.dart';

class BuscarRegistroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BuscarRegistroController>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar...',
            icon: Icon(Icons.search),
          ),
          onChanged: (query) => controller.buscarProductos(query),
        ),
      ),
      body: ListView.builder(
        itemCount: controller.resultadosBusqueda.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(controller.resultadosBusqueda[index].nombre),
          subtitle: Text('Cantidad: ${controller.resultadosBusqueda[index].cantidad}'),
        ),
      ),
    );
  }
}