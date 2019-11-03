import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';

class BalanceDiarioPage extends StatefulWidget {
  BalanceDiarioPage({Key key}) : super(key: key);

  _BalanceDiarioPageState createState() => _BalanceDiarioPageState();
}

class _BalanceDiarioPageState extends State<BalanceDiarioPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String rutaActiva = Routes.balanceDiario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Balance Diario"),
      ),
      drawer: AppDrawer(this.rutaActiva),
      body: Container(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "btnIngreso",
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add, color: Colors.black,),
            onPressed: (){

              DBProvider.db.existenTiposTransaccion("I").then((existe){
                if(existe){
                  Navigator.pushNamed(context, Routes.registroTransacciones);
                }else{
                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: 
                      Text('No hay tipos de transacciones de Ingreso. cree al menos una para continuar!!!'))); 
                }
              });
            },
          ),
          SizedBox(height: 10.0,),
          FloatingActionButton(
            heroTag: "btnGasto",
            backgroundColor: Colors.red,
            child: Icon(Icons.remove, color: Colors.black,),
            onPressed: (){

              DBProvider.db.existenTiposTransaccion("G").then((existe){
                if(existe){
                    Navigator.pushNamed(context, Routes.registroTransacciones);
                }else{
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: 
                        Text('No hay tipos de transacciones de gasto. cree al menos una para continuar!!!'))); 
                }
              });              
            },
          )
        ],
      ),
    );
  }
}