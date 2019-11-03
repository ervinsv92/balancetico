import 'package:balancetico/models/BETipoTransaccion.dart';

class BETransaccion{
  int idTransaccion;
  BETipoTransaccion tipoTransaccion;
  double monto;
  DateTime fechaRegistro;

  BETransaccion({this.idTransaccion = 0, this.tipoTransaccion, this.monto, this.fechaRegistro});

  factory BETransaccion.fromJson(Map<String, dynamic> json) => new BETransaccion(
    idTransaccion: json["idTransaccion"],
    tipoTransaccion: json["tipoTransaccion"],
    monto: json["monto"],
    fechaRegistro: json["fechaRegistro"],
  );

  Map<String, dynamic> toJson() => {
    "idTransaccion":idTransaccion,
    "idTipoTransaccion":tipoTransaccion.idTipoTransaccion,
    "monto":monto
  };
}