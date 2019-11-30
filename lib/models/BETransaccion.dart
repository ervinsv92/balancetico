import 'package:balancetico/models/BETipoTransaccion.dart';

class BETransaccion{
  int idTransaccion;
  BETipoTransaccion tipoTransaccion;
  double monto;
  DateTime fechaRegistro;
  DateTime fechaDocumento;
  double montoIngresos;
  double montoGastos;
  double montoDiferencia;

  BETransaccion({this.idTransaccion = 0, this.tipoTransaccion, this.monto, this.fechaDocumento, this.fechaRegistro});

  factory BETransaccion.fromJson(Map<String, dynamic> json) {

    BETransaccion transaccion = new BETransaccion();
    transaccion.idTransaccion = json["idTransaccion"];
    transaccion.monto = double.parse(json["monto"].toString());
    transaccion.tipoTransaccion = new BETipoTransaccion();
    transaccion.fechaRegistro = new DateTime.fromMillisecondsSinceEpoch(int.parse(json["fechaRegistro"].toString())*1000).toLocal();
    transaccion.fechaDocumento = new DateTime.fromMillisecondsSinceEpoch(int.parse(json["fechaDocumento"].toString())*1000).toLocal();
    transaccion.tipoTransaccion = new BETipoTransaccion();
    transaccion.tipoTransaccion.idTipoTransaccion = json["idTipoTransaccion"];
    transaccion.tipoTransaccion.nombre = json["nombre"];
    transaccion.tipoTransaccion.tipo = json["tipo"];
    return transaccion;
  }

  Map<String, dynamic> toJson() => {
    "idTransaccion":idTransaccion,
    "idTipoTransaccion":tipoTransaccion.idTipoTransaccion,
    "monto":monto,
    "fechaDocumento":fechaDocumento,
    "fechaRegistro":fechaRegistro
  };
}