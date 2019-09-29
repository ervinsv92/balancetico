import 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:flutter/material.dart';

class RegistroCategoriaPage extends StatefulWidget {
  RegistroCategoriaPage({Key key}) : super(key: key);

  _RegistroCategoriaPageState createState() => _RegistroCategoriaPageState();
}

class _RegistroCategoriaPageState extends State<RegistroCategoriaPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _txtNombreTransaccionController = TextEditingController();
  String _cmbTipoTransaccion = "Ingreso";

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _txtNombreTransaccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Registrar Categoria"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
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
              TextFormField(
                decoration: InputDecoration(labelText: "Nombre Categoria"),
                validator: (value) {
                  if (value.isEmpty || value.trim() == "") {
                    return "Debe digitar una categoría";
                  }
                },
                controller: _txtNombreTransaccionController,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    color: Colors.lightGreen,
                    minWidth: double.infinity,
                    padding: EdgeInsets.all(12.0),
                    child: Text("Guardar", style: TextStyle(fontSize: 20.0)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {

                        BETipoTransaccion tipoTransaccion = new BETipoTransaccion(
                          nombre: _txtNombreTransaccionController.text, 
                          tipo: _cmbTipoTransaccion[0]);

                        //print(tipoTransaccion.toJson());
                        DBProvider.db.guardarCategoria(tipoTransaccion);

                        // Si el formulario es válido, muestre un snackbar. En el mundo real, a menudo
                        // desea llamar a un servidor o guardar la información en una base de datos
                        /* _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Processing Data'))); */

                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
