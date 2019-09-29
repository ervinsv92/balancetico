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
          _crearEncabezado(),
          _createDrawerItem(
              text: "Balance Diario",
              ruta: Routes.balanceDiario,
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.balanceDiario)),
          _createDrawerItem(
              text: "Balance Rango",
              ruta: Routes.balanceRango,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.balanceRango)),
          _createDrawerItem(
              text: "Lista Categorias",
              ruta: Routes.listaCategoria,
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.listaCategoria)),
        ],
      ),
    );
  }

  Widget _crearEncabezado() {
    return DrawerHeader(
      child: Text("Encabezado drawer"),
    );
  }

  Widget _createDrawerItem({String text, String ruta, GestureTapCallback onTap}) {
    return ListTile(
      title: Text(text),
      selected: rutaActiva == ruta,
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
      onTap: onTap,
    );
  }
}
