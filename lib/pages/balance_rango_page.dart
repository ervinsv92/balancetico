import 'package:balancetico/models/BETotalesTransaccion.dart';
import 'package:balancetico/models/BETransaccion.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceRangoPage extends StatefulWidget {
  int idTipoTransaccion = 0;
  DateTime fechaInicio;
  DateTime fechaFinal;
  BalanceRangoPage({Key key, this.idTipoTransaccion, this.fechaInicio, this.fechaFinal}) : super(key: key);

  _BalanceRangoPageState createState() => _BalanceRangoPageState();
}

class _BalanceRangoPageState extends State<BalanceRangoPage> {
  final String rutaActiva = Routes.balanceRango;
  final formatoFecha = DateFormat('dd/MM/yyyy');
  final formatoNumero = NumberFormat('###,###,###,###.0#');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<BETransaccion> _listaTransaccion;
  BETotalesTransaccion _totalesTransaccion;

  @override
  void initState() {
    super.initState();
    _obtenerTransaccion();
    _obtenerTotalesTransaccion();
  }

  void _obtenerTransaccion() async {
    _listaTransaccion = await DBProvider.db.obtenerTransaccionRango(widget.fechaInicio, widget.fechaFinal, widget.idTipoTransaccion);
    setState(() {});
  }

  void _obtenerTotalesTransaccion() async{
      _totalesTransaccion = await DBProvider.db.obtenerTotalesTransaccionRango(widget.fechaInicio, widget.fechaFinal, widget.idTipoTransaccion);
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balance Rango"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                    itemCount: _listaTransaccion.length,
                    itemBuilder: (context, i) => Column(
                      children: <Widget>[
                        ListTile(
                            trailing: Text(
                                formatoNumero.format(_listaTransaccion[i].monto),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color:
                                        _listaTransaccion[i].tipoTransaccion.tipo ==
                                                "I"
                                            ? Colors.green
                                            : Colors.red)),
                            title: Text(_listaTransaccion[i].tipoTransaccion.nombre),
                            subtitle: Text(formatoFecha
                                .format(_listaTransaccion[i].fechaDocumento)),
                            onTap: () {
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Eliminar"),
                                      content: Text(
                                          "¿Desea eliminar la transacción?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Si"),
                                          onPressed: () {
                                            DBProvider.db.borrarTransaccion(_listaTransaccion[i].idTransaccion).then((data) {
                                                if (data > 0) {
                                                  Navigator.of(context).pop();
                                                _obtenerTransaccion();
                                                _obtenerTotalesTransaccion();
                                              } else {
                                                _scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Error al borrar la transacción. Intente de nuevo.')));
                                              }
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }),
                        Divider(
                          height: 2.0,
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                  )
            ),
            Container(
            margin: EdgeInsets.only(bottom: 5.0, left: 15.0),
            child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Total:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Expanded(child: Container(),),
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Text(
                              formatoNumero.format(_totalesTransaccion.totalDiferencia),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Container(
                            height: 30.0,
                          )
                        ],
                      )
                    ],
                  )
          )
          ],
          
        ),
      ),
    );
  }
}
