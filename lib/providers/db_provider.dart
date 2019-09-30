
import 'dart:io';
import 'package:balancetico/models/BETipoTransaccion.dart';
export 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();//Constructor privado para que solo se cree una vez

  //Nombres de tablas
  final String _tipo_transaccion_tabla = "TipoTransaccion";
  final String _transaccion_tabla = "Transaccion";

  DBProvider._();

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "BalanceticoDB.db");

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE TipoTransaccion ("
          "idTipoTransaccion INTEGER PRIMARY KEY AUTOINCREMENT,"
          "nombre TEXT NOT NULL,"
          "tipo TEXT NOT NULL"
          ")"
        );

        await db.execute(
          "CREATE TABLE Transaccion ("
          "idTransaccion INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
          "idTipoTransaccion INTEGER NOT NULL,"
          "monto NUMERIC NOT NULL DEFAULT 0,"
          "fechaRegistro INTEGER NOT NULL,"
          "foreign key(idTipoTransaccion) references TipoTransaccion(idTipoTransaccion)"
          ")"
        );
      }
    );
  }

  //Metodos db
  Future<int> guardarTipoTransaccion(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO TipoTransaccion (nombre, tipo) "
      "VALUES(?, ?);", [tipoTransaccion.nombre, tipoTransaccion.tipo]
    );
    return res;
  }

  Future<int> guardarTipoTransaccionNoSirve(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = await db.insert(_tipo_transaccion_tabla, tipoTransaccion.toJson());
    return res;
  }

  Future<int> actualizarTipoTransaccion(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = await db.update(_tipo_transaccion_tabla, 
    tipoTransaccion.toJson(), where:"idTipoTransaccion = ?", whereArgs: [tipoTransaccion.idTipoTransaccion]);
    return res;
  }

  Future<bool> existeTipoTransaccion(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_tipo_transaccion_tabla WHERE idTipoTransaccion <> ? AND nombre = ? AND tipo = ?', 
    [tipoTransaccion.idTipoTransaccion, tipoTransaccion.nombre, tipoTransaccion.tipo]));

    return res > 0 ? true:false;
  }

  Future<bool> existeTransaccionDeTipoTransaccion(int idTipoTransaccion) async{
    final db = await database;
    final res = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_transaccion_tabla WHERE idTipoTransaccion = ?', [idTipoTransaccion]));

    return res > 0 ? true:false;
  }

  Future<BETipoTransaccion> obtenerTipoTransaccionId(int idTipoTransaccion) async {
    final db = await database;
    final res = await db.query(_tipo_transaccion_tabla, where: "idTipoTransaccion = ?", whereArgs: [idTipoTransaccion]);

    return res.isNotEmpty ? BETipoTransaccion.fromJson(res.first) : null;
  }

  Future<List<BETipoTransaccion>> obtenerTiposTransaccionPorTipo(String tipo) async {
    final db = await database;
    final res = await db.query(_tipo_transaccion_tabla, where: "tipo = ?", whereArgs: [tipo]);

    List<BETipoTransaccion> list = res.isNotEmpty 
    ? res.map((tipoTransaccion) => BETipoTransaccion.fromJson(tipoTransaccion)).toList() : [];

    return list;
  }

  Future<int> borrarTipoTransaccion(int idTipoTransaccion) async{
    final db = await database;
    final res = db.delete(_tipo_transaccion_tabla, where:"idTipoTransaccion = ?", whereArgs: [idTipoTransaccion]);
    return res;
  }

  Future<int> borrarTipoTransaccionTodos() async{
    final db = await database;
    final res = db.rawDelete("DELETE FROM $_tipo_transaccion_tabla");
    return res;
  }
}