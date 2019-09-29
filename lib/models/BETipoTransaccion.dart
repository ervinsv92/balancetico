class BETipoTransaccion{
  int idTipoTransaccion;
  String nombre;
  String tipo;

  BETipoTransaccion({this.idTipoTransaccion = 0, this.nombre, this.tipo});

  factory BETipoTransaccion.fromJson(Map<String, dynamic> json) => new BETipoTransaccion(
    idTipoTransaccion: json["idTipoTransaccion"],
    nombre: json["nombre"],
    tipo: json["tipo"],
  );

  Map<String, dynamic> toJson() => {
    "idTipoTransaccion":idTipoTransaccion,
    "nombre":nombre,
    "tipo":tipo
  };
}