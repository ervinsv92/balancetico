import 'dart:io';
import 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:balancetico/models/BETotalesTransaccion.dart';
import 'package:balancetico/models/BETransaccion.dart';
export 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db =
      DBProvider._(); //Constructor privado para que solo se cree una vez

  //Nombres de tablas
  final String _tipo_transaccion_tabla = "TipoTransaccion";
  final String _transaccion_tabla = "Transaccion";

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "BalanceticoDB.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE TipoTransaccion ("
          "idTipoTransaccion INTEGER PRIMARY KEY AUTOINCREMENT,"
          "nombre TEXT NOT NULL,"
          "tipo TEXT NOT NULL"
          ")");

      await db.execute("CREATE TABLE Transaccion ("
          "idTransaccion INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
          "idTipoTransaccion INTEGER NOT NULL,"
          "monto DECIMAL(18,2) NOT NULL DEFAULT 0,"
          "fechaDocumento INTEGER NOT NULL,"
          "fechaRegistro INTEGER NOT NULL,"
          "foreign key(idTipoTransaccion) references TipoTransaccion(idTipoTransaccion)"
          ")");
    });
  }

  //Metodos db
  Future<int> guardarTipoTransaccion(BETipoTransaccion tipoTransaccion) async {
    final db = await database;
    final res = await db.rawInsert(
        "INSERT INTO TipoTransaccion (nombre, tipo) "
        "VALUES(?, ?);",
        [tipoTransaccion.nombre, tipoTransaccion.tipo]);
    return res;
  }

  Future<int> guardarTransaccion(BETransaccion transaccion) async {
    final db = await database;
    final res = await db.rawInsert(
        "INSERT INTO Transaccion (idTipoTransaccion, monto, fechaDocumento, fechaRegistro) "
        "VALUES(?, ?, ?, strftime('%s','now'));",
        [
          transaccion.tipoTransaccion.idTipoTransaccion,
          transaccion.monto,
          convertirFechaASegundos(transaccion.fechaDocumento)
        ]);
    return res;
  }

  Future<int> guardarTipoTransaccionNoSirve(
      BETipoTransaccion tipoTransaccion) async {
    final db = await database;
    final res =
        await db.insert(_tipo_transaccion_tabla, tipoTransaccion.toJson());
    return res;
  }

  Future<int> actualizarTipoTransaccion(
      BETipoTransaccion tipoTransaccion) async {
    final db = await database;
    final res = await db.update(
        _tipo_transaccion_tabla, tipoTransaccion.toJson(),
        where: "idTipoTransaccion = ?",
        whereArgs: [tipoTransaccion.idTipoTransaccion]);
    return res;
  }

  Future<bool> existeTipoTransaccion(BETipoTransaccion tipoTransaccion) async {
    final db = await database;
    final res = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $_tipo_transaccion_tabla WHERE idTipoTransaccion <> ? AND nombre = ? AND tipo = ?',
        [
          tipoTransaccion.idTipoTransaccion,
          tipoTransaccion.nombre,
          tipoTransaccion.tipo
        ]));

    return res > 0 ? true : false;
  }

  Future<bool> existenTiposTransaccion(String tipo) async {
    final db = await database;
    final res = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $_tipo_transaccion_tabla WHERE tipo = ?',
        [tipo]));

    return res > 0 ? true : false;
  }

  Future<bool> existeTransaccionDeTipoTransaccion(int idTipoTransaccion) async {
    final db = await database;
    final res = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $_transaccion_tabla WHERE idTipoTransaccion = ?',
        [idTipoTransaccion]));

    return res > 0 ? true : false;
  }

  Future<BETipoTransaccion> obtenerTipoTransaccionId(
      int idTipoTransaccion) async {
    final db = await database;
    final res = await db.query(_tipo_transaccion_tabla,
        where: "idTipoTransaccion = ?", whereArgs: [idTipoTransaccion]);

    return res.isNotEmpty ? BETipoTransaccion.fromJson(res.first) : null;
  }

  Future<List<BETipoTransaccion>> obtenerTiposTransaccionPorTipo(
      String tipo) async {
    final db = await database;
    final res = await db
        .query(_tipo_transaccion_tabla, where: "tipo = ?", whereArgs: [tipo]);

    List<BETipoTransaccion> list = res.isNotEmpty
        ? res
            .map((tipoTransaccion) =>
                BETipoTransaccion.fromJson(tipoTransaccion))
            .toList()
        : [];

    return list;
  }

  Future<List<BETransaccion>> obtenerTransaccionesDelDia() async {
    final db = await database;
 
    final String consulta =
        '''SELECT Transaccion.idTransaccion, Transaccion.monto, Transaccion.fechaDocumento, Transaccion.fechaRegistro, TipoTransaccion.idTipotransaccion, 
                                TipoTransaccion.nombre, TipoTransaccion.tipo
                                FROM $_transaccion_tabla 
                                JOIN $_tipo_transaccion_tabla ON $_transaccion_tabla.idTipoTransaccion = $_tipo_transaccion_tabla.idTipoTransaccion 
                                WHERE DATETIME(fechaDocumento, 'unixepoch', 'localtime') = strftime('%Y-%m-%d 00:00:00', DATETIME('now', 'localtime'))
                                ORDER BY fechaRegistro''';
    final res = await db.rawQuery(consulta);

    List<BETransaccion> list = res.isNotEmpty
        ? res.map((transaccion) => BETransaccion.fromJson(transaccion)).toList()
        : [];

    return list;
  }

  Future<List<BETransaccion>> obtenerTransaccionRango(DateTime fechaInicio, DateTime fechaFinal, int tipoTransaccion) async {
    final db = await database;
    String fechaI = fechaInicio.toLocal().toString();
    String fechaF = fechaFinal.toLocal().toString();

    final String consulta =
        '''SELECT Transaccion.idTransaccion, Transaccion.monto, Transaccion.fechaDocumento, Transaccion.fechaRegistro, TipoTransaccion.idTipotransaccion, 
                                TipoTransaccion.nombre, TipoTransaccion.tipo
                                FROM $_transaccion_tabla 
                                JOIN $_tipo_transaccion_tabla ON $_transaccion_tabla.idTipoTransaccion = $_tipo_transaccion_tabla.idTipoTransaccion 
                                WHERE DATETIME(fechaDocumento, 'unixepoch', 'localtime') BETWEEN strftime('%Y-%m-%d 00:00:00', '$fechaI') AND strftime('%Y-%m-%d 00:00:00', '$fechaF')
                                AND $_transaccion_tabla.idTipoTransaccion = $tipoTransaccion
                                ORDER BY fechaRegistro''';
    final res = await db.rawQuery(consulta);

    List<BETransaccion> list = res.isNotEmpty
        ? res.map((transaccion) => BETransaccion.fromJson(transaccion)).toList()
        : [];

    return list;
  }

  Future<List<BETransaccion>> obtenerTransaccionesRangoGrupo(DateTime fechaInicio, DateTime fechaFinal) async {
    final db = await database;
    String fechaI = fechaInicio.toLocal().toString();
    String fechaF = fechaFinal.toLocal().toString();

    final String consulta =
        '''SELECT TipoTransaccion.idTipotransaccion, TipoTransaccion.nombre, TipoTransaccion.tipo, SUM(Transaccion.monto) AS monto,
                  0 AS idTransaccion, 0 AS fechaDocumento, 0 AS fechaRegistro
                  FROM $_transaccion_tabla 
                  JOIN $_tipo_transaccion_tabla ON $_transaccion_tabla.idTipoTransaccion = $_tipo_transaccion_tabla.idTipoTransaccion 
                  WHERE DATETIME(fechaDocumento, 'unixepoch', 'localtime') BETWEEN strftime('%Y-%m-%d 00:00:00', '$fechaI') AND strftime('%Y-%m-%d 00:00:00', '$fechaF')
                  GROUP BY TipoTransaccion.idTipotransaccion, TipoTransaccion.nombre, TipoTransaccion.tipo
                  ORDER BY TipoTransaccion.nombre''';
    final res = await db.rawQuery(consulta);

    List<BETransaccion> list = res.isNotEmpty
        ? res.map((transaccion) => BETransaccion.fromJson(transaccion)).toList()
        : [];

    return list;
  }

  Future<BETotalesTransaccion> obtenerTotalesTransaccionesDelDia() async {
    final db = await database;
    BETotalesTransaccion totales = new BETotalesTransaccion();
    final String consultaTotales =
        '''SELECT round(SUM(CASE WHEN tipo = 'I' THEN monto ELSE 0 END), 2) AS montoIngresos, 
                                    round(SUM(CASE WHEN tipo = 'G' THEN monto ELSE 0 END), 2) AS montoGastos
                                    FROM $_transaccion_tabla 
                                    JOIN $_tipo_transaccion_tabla ON $_transaccion_tabla.idTipoTransaccion = $_tipo_transaccion_tabla.idTipoTransaccion 
                                    WHERE DATETIME(fechaDocumento, 'unixepoch', 'localtime') = strftime('%Y-%m-%d 00:00:00', DATETIME('now', 'localtime'))''';
    
    final resTotales = await db.rawQuery(consultaTotales);

    if (resTotales.isNotEmpty) {
    
      Map<String, dynamic> mapTotales = resTotales.first;

      if(mapTotales["montoIngresos"] != null){
        totales = new BETotalesTransaccion();
        totales.totalIngresos = double.parse(mapTotales["montoIngresos"].toString());
        totales.totalGastos = double.parse(mapTotales["montoGastos"].toString());
        totales.totalDiferencia = totales.totalIngresos - totales.totalGastos;
      }
    }

  return totales;
  }

  Future<BETotalesTransaccion> obtenerTotalesTransaccionRango(DateTime fechaInicio, DateTime fechaFinal, int tipoTransaccion) async {
    final db = await database;
    BETotalesTransaccion totales = new BETotalesTransaccion();
    String fechaI = fechaInicio.toLocal().toString();
    String fechaF = fechaFinal.toLocal().toString();

    final String consultaTotales =
        '''SELECT round(SUM(monto), 2) AS monto
            FROM $_transaccion_tabla 
            JOIN $_tipo_transaccion_tabla ON $_transaccion_tabla.idTipoTransaccion = $_tipo_transaccion_tabla.idTipoTransaccion 
            WHERE DATETIME(fechaDocumento, 'unixepoch', 'localtime') BETWEEN strftime('%Y-%m-%d 00:00:00', '$fechaI') AND strftime('%Y-%m-%d 00:00:00', '$fechaF')
            AND $_transaccion_tabla.idTipoTransaccion = $tipoTransaccion''';
    
    final resTotales = await db.rawQuery(consultaTotales);

    if (resTotales.isNotEmpty) {
    
      Map<String, dynamic> mapTotales = resTotales.first;

      if(mapTotales["monto"] != null){
        totales = new BETotalesTransaccion();
        totales.totalIngresos = 0;
        totales.totalGastos = 0;
        totales.totalDiferencia = double.parse(mapTotales["monto"].toString());
      }
    }

  return totales;
  }

  Future<BETotalesTransaccion> obtenerTotalesTransaccionesRangoGrupo(DateTime fechaInicio, DateTime fechaFinal) async {
    final db = await database;
    BETotalesTransaccion totales = new BETotalesTransaccion();
    String fechaI = fechaInicio.toLocal().toString();
    String fechaF = fechaFinal.toLocal().toString();

    final String consultaTotales =
        '''SELECT round(SUM(CASE WHEN tipo = 'I' THEN monto ELSE 0 END), 2) AS montoIngresos, 
                                    round(SUM(CASE WHEN tipo = 'G' THEN monto ELSE 0 END), 2) AS montoGastos
                                    FROM $_transaccion_tabla 
                                    JOIN $_tipo_transaccion_tabla ON $_transaccion_tabla.idTipoTransaccion = $_tipo_transaccion_tabla.idTipoTransaccion 
                                    WHERE DATETIME(fechaDocumento, 'unixepoch', 'localtime') BETWEEN strftime('%Y-%m-%d 00:00:00', '$fechaI') AND strftime('%Y-%m-%d 00:00:00', '$fechaF')''';
    
    final resTotales = await db.rawQuery(consultaTotales);

    if (resTotales.isNotEmpty) {
    
      Map<String, dynamic> mapTotales = resTotales.first;

      if(mapTotales["montoIngresos"] != null){
        totales = new BETotalesTransaccion();
        totales.totalIngresos = double.parse(mapTotales["montoIngresos"].toString());
        totales.totalGastos = double.parse(mapTotales["montoGastos"].toString());
        totales.totalDiferencia = totales.totalIngresos - totales.totalGastos;
      }
    }

  return totales;
  }

  Future<int> borrarTipoTransaccion(int idTipoTransaccion) async {
    final db = await database;
    final res = db.delete(_tipo_transaccion_tabla,
        where: "idTipoTransaccion = ?", whereArgs: [idTipoTransaccion]);
    return res;
  }

  Future<int> borrarTransaccion(int idTransaccion) async {
    final db = await database;
    final res = db.delete(_transaccion_tabla,
        where: "idTransaccion = ?", whereArgs: [idTransaccion]);
    return res;
  }

  Future<int> borrarTipoTransaccionTodos() async {
    final db = await database;
    final res = db.rawDelete("DELETE FROM $_tipo_transaccion_tabla");
    return res;
  }

  static int convertirFechaASegundos(DateTime fecha) {
    var ms = fecha.millisecondsSinceEpoch;
    //var unix = (ms / 1000).round();
    return (ms / 1000).round();
  }
}
