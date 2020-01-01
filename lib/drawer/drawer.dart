import 'package:flutter/material.dart';
import 'package:balancetico/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer(this.rutaActiva);
  final String rutaActiva;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _crearEncabezado(context),
          _createDrawerItem(
              text: "Balance Diario",
              ruta: Routes.balanceDiario,
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.balanceDiario)),
          _createDrawerItem(
              text: "Balance Rango Grupo",
              ruta: Routes.balanceRangoGrupo,
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.balanceRangoGrupo)),
          _createDrawerItem(
              text: "Lista Tipo Transacción",
              ruta: Routes.listaCategoria,
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.listaCategoria)),
        ],
      ),
    );
  }

  Widget _crearEncabezado(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.account_balance),
              Text(
                "Balancetico",
                style: TextStyle(
                    fontSize: 22.0, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 10.0),
            child: Text(
              "Lleva el control de tus ingresos y gastos.",
              textAlign: TextAlign.left,
            ),
          ),
          Text("Hecho con Flutter", style: TextStyle(color: Colors.blue))
        ]
          )
    );
  }

  Widget _createDrawerItem(
      {String text, String ruta, GestureTapCallback onTap}) {
    return ListTile(
      title: Text(text),
      selected: rutaActiva == ruta,
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
      onTap: onTap,
    );
  }
}
