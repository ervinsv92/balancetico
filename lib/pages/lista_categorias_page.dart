import 'package:balancetico/drawer/drawer.dart';
import 'package:balancetico/providers/db_provider.dart';
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
            child: FutureBuilder<List<BETipoTransaccion>>(
              future: DBProvider.db.obtenerTiposTransaccionPorTipo(_cmbTipoTransaccion[0]),
              builder: (BuildContext context, AsyncSnapshot<List<BETipoTransaccion>> snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }

                final tiposTransaccion = snapshot.data;

                if(tiposTransaccion.length == 0){
                  return Center(child: Text("No hay información"),);
                }

                return ListView.builder(
                  itemCount: tiposTransaccion.length,
                  itemBuilder: (context, i) => ListTile(
                    trailing: Icon(Icons.arrow_right),
                    title: Text(tiposTransaccion[i].nombre),
                    onTap: (){
                      Navigator.pushNamed(context, Routes.registroCategoria,arguments: tiposTransaccion[i]);
                    },
                  ),
                );
              },
            )
          ),
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
