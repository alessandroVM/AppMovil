class Producto {
  final String id;
  final String codigo;       // Nuevo campo (Código único del producto)
  final String nombre;
  final String categoria;
  final String serie;        // Nuevo campo (Número de serie)
  final String estatus;      // Nuevo campo ('Activo'/'Inactivo')
  final dynamic cantidad;  // Cambiado a dynamic para manejar ambos tipos
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
      categoria: json['categoria'] ?? 'Nuevo', // Valor por defecto
      serie: json['serie'] ?? '',        // Añadido
      estatus: json['estatus'] ?? 'Activo', // Valor por defecto
      cantidad: _parseCantidad(json['cantidad']),  // Función de parseo especial
      //cantidad: (json['cantidad'] as num).toInt(), // toInt // toDouble
      codigoQR: json['codigoQR'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  static dynamic _parseCantidad(dynamic cantidad) {
    if (cantidad == null) return 0;
    if (cantidad is num) return cantidad;
    if (cantidad is String) {
      return num.tryParse(cantidad) ?? 0;  // Convierte String a num
    }
    return 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'codigo': codigo,        // Añadido
    'nombre': nombre,
    'categoria': categoria,
    'serie': serie,          // Añadido
    'estatus': estatus,      // Añadido
    //'cantidad': cantidad,
    'cantidad': cantidad.toString(),  // Asegura conversión a String
    'codigoQR': codigoQR,
    'fechaRegistro': fechaRegistro.toIso8601String(), // Metodo para fechas
  };
}