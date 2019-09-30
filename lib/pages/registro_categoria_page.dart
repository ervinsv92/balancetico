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
  String _tituloPagina = "Registrar Tipo Transacción";

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _txtNombreTransaccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final BETipoTransaccion _tipoTransaccionParam = ModalRoute.of(context).settings.arguments;
    if(_tipoTransaccionParam != null){
      _cmbTipoTransaccion = _tipoTransaccionParam.tipo == "I"?"Ingreso":"Gasto";
      _txtNombreTransaccionController.text = _tipoTransaccionParam.nombre;
      _tituloPagina = "Modificar Tipo Transacción";
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_tituloPagina),
        actions: <Widget>[
          _tipoTransaccionParam != null?IconButton(
            icon: Icon(Icons.delete, color: Colors.black,),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Eliminar"),
                    content: Text("¿Desea eliminar el tipo de transacción?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Si"),
                        onPressed: (){
                            DBProvider.db.existeTransaccionDeTipoTransaccion(_tipoTransaccionParam.idTipoTransaccion).then((data){
                                if(!data){
                                  DBProvider.db.borrarTipoTransaccion(_tipoTransaccionParam.idTipoTransaccion);
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                }else{
                                  _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(content: Text('El nombre del tipo de transacción ya existe. Intente de nuevo.'))); 
                                }
                            });
                        },
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
            },
          ):Container()
        ],
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
                    color: Theme.of(context).primaryColor,
                    minWidth: double.infinity,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Guardar",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        BETipoTransaccion tipoTransaccion =
                            new BETipoTransaccion(
                                nombre: _txtNombreTransaccionController.text,
                                tipo: _cmbTipoTransaccion[0]);

                        if(_tipoTransaccionParam != null){
                          tipoTransaccion.idTipoTransaccion = _tipoTransaccionParam.idTipoTransaccion;
                        }

                        DBProvider.db.existeTipoTransaccion(tipoTransaccion).then((data) {
                          if (!data) {
                            if(tipoTransaccion.idTipoTransaccion == 0){
                              DBProvider.db.guardarTipoTransaccion(tipoTransaccion);
                            }else{
                              DBProvider.db.actualizarTipoTransaccion(tipoTransaccion);
                            }

                            Navigator.pop(context);
                          }else{
                            _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('El nombre del tipo de transacción ya existe. Intente de nuevo.'))); 
                          }
                        });
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
