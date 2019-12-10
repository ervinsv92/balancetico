import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/models/BETotalesTransaccion.dart';
import 'package:balancetico/models/BETransaccion.dart';
import 'package:balancetico/pages/registro_transacciones_page.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceDiarioPage extends StatefulWidget {
  BalanceDiarioPage({Key key}) : super(key: key);

  _BalanceDiarioPageState createState() => _BalanceDiarioPageState();
}

class _BalanceDiarioPageState extends State<BalanceDiarioPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String rutaActiva = Routes.balanceDiario;
  final formatoFecha = DateFormat('dd/MM/yyyy HH:mm');
  final formatoNumero = NumberFormat('###,###,###,###.0#');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Balance Diario"),
      ),
      drawer: AppDrawer(this.rutaActiva),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: DBProvider.db.obtenerTransaccionesDelDia(),
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
                          //leading: Text("numero 1"),
                          subtitle: Text(formatoFecha
                              .format(transacciones[i].fechaRegistro)),
                          //subtitle: Text(transacciones[i].fechaRegistro.toString()),
                          onTap: () {
                            //Navigator.pushNamed(context, Routes.registroCategoria,arguments: transacciones[i]);
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
                                          DBProvider.db.borrarTransaccion(transacciones[i].idTransaccion).then((data) {
                                              if (data > 0) {
                                              
                                              Navigator.of(context).pop();
                                              setState(() {});
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
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 25.0),
            height: 150.0,
            child: FutureBuilder(
                future: DBProvider.db.obtenerTotalesTransaccionesDelDia(),
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
                          Container(
                            width: 16.0,
                          ),
                          Text(
                            formatoNumero.format(totales.totalIngresos),
                            style: TextStyle(fontSize: 18.0),
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
                          Container(
                            width: 28.0,
                          ),
                          Text(
                            formatoNumero.format(totales.totalGastos),
                            style: TextStyle(fontSize: 18.0),
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
                          Container(
                            width: 5.0,
                          ),
                          Text(
                            formatoNumero.format(totales.totalDiferencia),
                            style: TextStyle(fontSize: 18.0),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "btnIngreso",
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              DBProvider.db.existenTiposTransaccion("I").then((existe) {
                if (existe) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegistroTransaccionesPage(tipoTransaccion: "I")));
                  //Navigator.pushNamed(context, Routes.registroTransacciones, arguments: "I");
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'No hay tipos de transacciones de Ingreso. cree al menos una para continuar!!!')));
                }
              });
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            heroTag: "btnGasto",
            backgroundColor: Colors.red,
            child: Icon(
              Icons.remove,
              color: Colors.black,
            ),
            onPressed: () {
              DBProvider.db.existenTiposTransaccion("G").then((existe) {
                if (existe) {
                  //Navigator.pushNamed(context, Routes.registroTransacciones, arguments: "G");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegistroTransaccionesPage(tipoTransaccion: "G")));
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'No hay tipos de transacciones de gasto. cree al menos una para continuar!!!')));
                }
              });
            },
          )
        ],
      ),
    );
  }
}
