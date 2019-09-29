import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';

class BalanceRangoPage extends StatefulWidget {
  BalanceRangoPage({Key key}) : super(key: key);

  _BalanceRangoPageState createState() => _BalanceRangoPageState();
}

class _BalanceRangoPageState extends State<BalanceRangoPage> {

  final String rutaActiva = Routes.balanceRango;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balance Rango"),
      ),
      drawer: AppDrawer(this.rutaActiva),
    );
  }
}