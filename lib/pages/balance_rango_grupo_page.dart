import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/models/BETotalesTransaccion.dart';
import 'package:balancetico/models/BETransaccion.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'balance_rango_page.dart';

class BalanceRangoGrupoPage extends StatefulWidget {
  BalanceRangoGrupoPage({Key key}) : super(key: key);

  _BalanceRangoGrupoPageState createState() => _BalanceRangoGrupoPageState();
}

class _BalanceRangoGrupoPageState extends State<BalanceRangoGrupoPage> {
  final String rutaActiva = Routes.balanceRangoGrupo;
  final formatoFecha = DateFormat('dd/MM/yyyy');
  final formatoNumero = NumberFormat('###,###,###,###.0#');
  DateTime _fechaInicio = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();
  DateTime _fechaFinal = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balance Rango Grupo"),
      ),
      drawer: AppDrawer(this.rutaActiva),
      body: Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Row(
              children: <Widget>[
                Text("Inicio: "),
                Icon(Icons.date_range),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    formatoFecha.format(_fechaInicio),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _fechaInicio,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((fecha) => {
                          if (fecha != null)
                            {
                              setState(() {
                                _fechaInicio = fecha.toLocal();
                              })
                            }
                        });
                  },
                ),
              ],
            ),
            Expanded(child: Container(),),
            Row(
              children: <Widget>[
                Text("Final: "),
                Icon(Icons.date_range),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    formatoFecha.format(_fechaFinal),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _fechaFinal,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((fecha) => {
                          if (fecha != null)
                            {
                              setState(() {
                                _fechaFinal = fecha.toLocal();
                              })
                            }
                        });
                  },
                ),
              ],
            ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: DBProvider.db.obtenerTransaccionesRangoGrupo(_fechaInicio, _fechaFinal),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BETransaccion>> snapshot) {
                      if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final transacciones = snapshot.data;

                  if (transacciones.length == 0) {
                    return Center(
                      child: Text("No hay información"),
                    );
                  }

                  return ListView.builder(
                    itemCount: transacciones.length,
                    itemBuilder: (context, i) => Column(
                      children: <Widget>[
                        ListTile(
                            trailing: Text(
                                formatoNumero.format(transacciones[i].monto),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color:
                                        transacciones[i].tipoTransaccion.tipo ==
                                                "I"
                                            ? Colors.green
                                            : Colors.red)),
                            title: Text(transacciones[i].tipoTransaccion.nombre),
                            onTap: () {
                              Navigator.push(
                              context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BalanceRangoPage(fechaInicio: _fechaInicio,fechaFinal: _fechaFinal,idTipoTransaccion: transacciones[i].tipoTransaccion.idTipoTransaccion,)));
                            },
                            ),
                        Divider(
                          height: 2.0,
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                  );
                    }
              ),
            ),
            Container(
            margin: EdgeInsets.only(bottom: 5.0, left: 15.0),
            child: FutureBuilder(
                future: DBProvider.db.obtenerTotalesTransaccionesRangoGrupo(_fechaInicio, _fechaFinal),
                builder: (BuildContext context,
                    AsyncSnapshot<BETotalesTransaccion> snapshot) {
                  final BETotalesTransaccion totales = snapshot.data;

                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Ingresos:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Expanded(child: Container(),),
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Text(
                              formatoNumero.format(totales.totalIngresos),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Container(
                            height: 30.0,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Gastos:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Expanded(child: Container(),),
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Text(
                              formatoNumero.format(totales.totalGastos),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Container(
                            height: 30.0,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Diferencia:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Expanded(child: Container(),),
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Text(
                              formatoNumero.format(totales.totalDiferencia),
                              style: TextStyle(fontSize: 18.0, color: totales.totalDiferencia >= 0? Colors.green: Colors.red),
                            ),
                          ),
                          Container(
                            height: 30.0,
                          )
                        ],
                      )
                    ],
                  );
                }),
          )
          ],
        ),
      ),
    );
  }
}
