import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/routes/routes.dart';
import 'package:flutter/material.dart';

class ListaCategoriasPage extends StatefulWidget {
  ListaCategoriasPage({Key key}) : super(key: key);

  _ListaCategoriasPageState createState() => _ListaCategoriasPageState();
}

class _ListaCategoriasPageState extends State<ListaCategoriasPage> {
  final String rutaActiva = Routes.listaCategoria;

  String _cmbTipoTransaccion = "Ingreso";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Categorias"),
      ),
      drawer: AppDrawer(this.rutaActiva),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: DropdownButton<String>(
              value: _cmbTipoTransaccion,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
              underline: Container(
                height: 2,
                color: Colors.lightGreen,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _cmbTipoTransaccion = newValue;
                });
              },
              items: <String>['Ingreso', 'Gasto']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Lista 1"),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                  width: 140.0,
                  padding: EdgeInsets.all(10.0),
                  color: Colors.green,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                        text: "2,000.00",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  )),
              Container(
                  width: 140.0,
                  padding: EdgeInsets.all(10.0),
                  color: Colors.red,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                        text: "500.00",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  )),
            ],
          ),
          Container(
              width: 280.0,
              padding: EdgeInsets.all(10.0),
              color: Colors.lightBlueAccent,
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                    text: "1,500.00",
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routes.registroCategoria);
        },
      ),
    );
  }
}
