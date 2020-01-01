
import 'dart:async';
import 'package:balancetico/providers/db_provider.dart';

class ListaCategoriasBloc {

  static final ListaCategoriasBloc _listaCategoriasBloc = new ListaCategoriasBloc._internal();

  factory ListaCategoriasBloc() => _listaCategoriasBloc;

  ListaCategoriasBloc._internal(){
    obtenerTiposTransaccionPorTipo("I");
  }

  final _listaCatBlocCtrl = StreamController<List<BETipoTransaccion>>.broadcast();

  Stream<List<BETipoTransaccion>> get listaCategoriasStr => _listaCatBlocCtrl.stream;

  dispose(){
    _listaCatBlocCtrl?.close();
  }

  obtenerTiposTransaccionPorTipo (String tipoTransaccion) async {
    _listaCatBlocCtrl.sink.add(await DBProvider.db.obtenerTiposTransaccionPorTipo(tipoTransaccion));
  }

  existeTipoTransaccion(BETipoTransaccion tipoTransaccion) async {
    return DBProvider.db.existeTipoTransaccion(tipoTransaccion);
  }
  
  guardarTipoTransaccion(BETipoTransaccion tipoTransaccion) async{
    await DBProvider.db.guardarTipoTransaccion(tipoTransaccion);
  }
  

}