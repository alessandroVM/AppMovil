class Usuario {
  final String id;
  final String nombre;
  final String rol; // 'admin' o 'empleado'

  Usuario({
    required this.id,
    required this.nombre,
    required this.rol,
  });
}