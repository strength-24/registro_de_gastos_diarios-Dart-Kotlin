class Transaccion {
  int? id;
  String descripcion;
  double monto;
  String tipo; // 'gasto' o 'ingreso'
  String fecha;

  Transaccion({
    this.id,
    required this.descripcion,
    required this.monto,
    required this.tipo,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'monto': monto,
      'tipo': tipo,
      'fecha': fecha,
    };
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'],
      descripcion: map['descripcion'],
      monto: map['monto'],
      tipo: map['tipo'],
      fecha: map['fecha'],
    );
  }
}
