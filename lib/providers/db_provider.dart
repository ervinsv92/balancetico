
import 'dart:io';
import 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();//Constructor privado para que solo se cree una vez

  //Nombres de tablas
  final String _TIPO_TRANSACCION_TABLA = "TipoTransaccion";

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
          "idTipoTransaccion INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
          "nombre TEXT NOT NULL UNIQUE,"
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
  guardarCategoriaEjemplo(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO TipoTransaccion (idTipoTransaccion, nombre, tipo)"
      "VALUES(${tipoTransaccion.idTipoTransaccion}, '${ tipoTransaccion.nombre }', '${ tipoTransaccion.tipo }');"
    );
    return res;
  }

  Future<int> guardarCategoria(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = await db.insert(_TIPO_TRANSACCION_TABLA, tipoTransaccion.toJson());
    return res;
  }

  Future<int> actualizarTipoTransaccion(BETipoTransaccion tipoTransaccion) async{
    final db = await database;
    final res = await db.update(_TIPO_TRANSACCION_TABLA, 
    tipoTransaccion.toJson(), where:"idTipoTransaccion = ?", whereArgs: [tipoTransaccion.idTipoTransaccion]);
    return res;
  }

  Future<BETipoTransaccion> obtenerTipoTransaccionId(int idTipoTransaccion) async {
    final db = await database;
    final res = await db.query(_TIPO_TRANSACCION_TABLA, where: "idTipoTransaccion = ?", whereArgs: [idTipoTransaccion]);

    return res.isNotEmpty ? BETipoTransaccion.fromJson(res.first) : null;
  }

  Future<List<BETipoTransaccion>> obtenerTiposTransaccionPorTipo(String tipo) async {
    final db = await database;
    final res = await db.query(_TIPO_TRANSACCION_TABLA, where: "tipo = ?", whereArgs: [tipo]);

    List<BETipoTransaccion> list = res.isNotEmpty 
    ? res.map((tipoTransaccion) => BETipoTransaccion.fromJson(tipoTransaccion)).toList() : [];

    return list;
  }

  Future<int> borrarTipoTransaccion(int idTipoTransaccion) async{
    final db = await database;
    final res = db.delete(_TIPO_TRANSACCION_TABLA, where:"idTipoTransaccion = ?", whereArgs: [idTipoTransaccion]);
    return res;
  }

  Future<int> borrarTipoTransaccionTodos() async{
    final db = await database;
    final res = db.rawDelete("DELETE FROM $_TIPO_TRANSACCION_TABLA");
    return res;
  }
}