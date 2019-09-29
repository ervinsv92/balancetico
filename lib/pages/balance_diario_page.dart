import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';

class BalanceDiarioPage extends StatefulWidget {
  BalanceDiarioPage({Key key}) : super(key: key);

  _BalanceDiarioPageState createState() => _BalanceDiarioPageState();
}

class _BalanceDiarioPageState extends State<BalanceDiarioPage> {

  final String rutaActiva = Routes.balanceDiario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balance Diario"),
      ),
      drawer: AppDrawer(this.rutaActiva),
    );
  }
}