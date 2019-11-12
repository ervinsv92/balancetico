class BETotalesTransaccion{
  double totalIngresos = 0; 
  double totalGastos = 0;
  double totalDiferencia = 0;

  BETotalesTransaccion({this.totalIngresos = 0, this.totalGastos = 0, this.totalDiferencia = 0});

  factory BETotalesTransaccion.fromJson(Map<String, dynamic> json) => new BETotalesTransaccion(
    totalIngresos: json["totalIngresos"],
    totalGastos: json["totalGastos"],
    totalDiferencia: json["totalDiferencia"],
  );

  Map<String, dynamic> toJson() => {
    "totalIngresos":totalIngresos,
    "totalGastos":totalGastos,
    "totalDiferencia":totalDiferencia
  };
}