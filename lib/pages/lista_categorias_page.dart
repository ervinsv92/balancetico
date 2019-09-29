import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';

class ListaCategoriasPage extends StatefulWidget {
  ListaCategoriasPage({Key key}) : super(key: key);

  _ListaCategoriasPageState createState() => _ListaCategoriasPageState();
}

class _ListaCategoriasPageState extends State<ListaCategoriasPage> {
  final String rutaActiva = Routes.listaCategoria;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Categorias"),
      ),
      drawer: AppDrawer(this.rutaActiva),
    );
  }
}