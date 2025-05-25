class Producto {
  final String id;
  final String codigo;       // Nuevo campo (Código único del producto)
  final String nombre;
  final String categoria;
  final String serie;        // Nuevo campo (Número de serie)
  final String estatus;      // Nuevo campo ('Activo'/'Inactivo')
  final int cantidad;
  final String codigoQR;
  final DateTime fechaRegistro;

  Producto({
    required this.id,
    required this.codigo,    // Añadido
    required this.nombre,
    required this.categoria,
    required this.serie,     // Añadido
    required this.estatus,   // Añadido
    required this.cantidad,
    required this.codigoQR,
    required this.fechaRegistro,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      codigo: json['codigo'] ?? '',      // Añadido
      nombre: json['nombre'],
      categoria: json['categoria'],
      serie: json['serie'] ?? '',        // Añadido
      estatus: json['estatus'] ?? 'Activo', // Valor por defecto
      cantidad: json['cantidad'],
      codigoQR: json['codigoQR'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'codigo': codigo,        // Añadido
    'nombre': nombre,
    'categoria': categoria,
    'serie': serie,          // Añadido
    'estatus': estatus,      // Añadido
    'cantidad': cantidad,
    'codigoQR': codigoQR,
    'fechaRegistro': fechaRegistro.toIso8601String(),
  };
}