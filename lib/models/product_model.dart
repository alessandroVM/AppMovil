class Producto {
  final String id;
  final String nombre;
  final String categoria;
  final int cantidad;
  final String codigoQR;
  final DateTime fechaRegistro;

  Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.codigoQR,
    required this.fechaRegistro,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      cantidad: json['cantidad'],
      codigoQR: json['codigoQR'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'categoria': categoria,
    'cantidad': cantidad,
    'codigoQR': codigoQR,
    'fechaRegistro': fechaRegistro.toIso8601String(),
  };
}