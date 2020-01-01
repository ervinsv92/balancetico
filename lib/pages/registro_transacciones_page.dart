import 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:balancetico/models/BETransaccion.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroTransaccionesPage extends StatefulWidget {
  String tipoTransaccion = "";
  RegistroTransaccionesPage({Key key, this.tipoTransaccion}) : super(key: key);

  _RegistroTransaccionesPageState createState() =>
      _RegistroTransaccionesPageState();
}

class _RegistroTransaccionesPageState extends State<RegistroTransaccionesPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _txtMontoController = TextEditingController();
  final formatoFecha = DateFormat('dd/MM/yyyy');
  String _titulo = "Registro transacción";
  BETipoTransaccion _cmbTipoTransaccion;
  List<BETipoTransaccion> _listaTipoTransaccion;
  DateTime _fecha = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();

  @override
  void initState() {
    super.initState();
    _obtenerTiposTransaccionPorTipo(widget.tipoTransaccion);
  }

  void _obtenerTiposTransaccionPorTipo(String tipoTransaccion) async {
    _listaTipoTransaccion = await DBProvider.db.obtenerTiposTransaccionPorTipo(tipoTransaccion);
    setState(() {});
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titulo),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                _listaTipoTransaccion == null ||
                        _listaTipoTransaccion.length <= 0
                    ? Text("No hay tipos de transacciones registradas!")
                    : DropdownButton<BETipoTransaccion>(
                        icon: Icon(Icons.arrow_right),
                        iconSize: 24.0,
                        elevation: 16,
                        value: _cmbTipoTransaccion,
                        hint: Text("Seleccione un tipo de transacción"),
                        isExpanded: true,
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                        underline: Container(
                          height: 2,
                          color: Colors.lightGreen,
                        ),
                        items: _listaTipoTransaccion
                            .map<DropdownMenuItem<BETipoTransaccion>>(
                                (BETipoTransaccion transMap) {
                          return DropdownMenuItem<BETipoTransaccion>(
                            value: transMap,
                            child: Text(transMap.nombre),
                          );
                        }).toList(),
                        onChanged: (BETipoTransaccion tipoTrans) {
                          setState(() {
                            _cmbTipoTransaccion = tipoTrans;
                          });
                        },
                      ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Monto"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty || value.trim() == "" || double.parse(value.trim()) == 0) {
                      return "El monto debe ser un número mayor a 0";
                    }
                  },
                  controller: _txtMontoController,
                ),
                Divider(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        formatoFecha.format(_fecha),
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: _fecha,
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2030),
                                builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child,
                                );
                              },
                              ).then((fecha) => {

                                if(fecha != null){
                                  setState(() {
                                      _fecha = fecha.toLocal();
                                  })
                                }
                              });
                      },
                    ),
                  ],
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
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {

                        if(_cmbTipoTransaccion == null){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: 
                        Text('Debe de seleccionar un tipo de transacción'))); 
                          return false;
                        }

                        if (_formKey.currentState.validate()) {
                            BETransaccion transaccion = new BETransaccion();
                            transaccion.monto = double.parse(_txtMontoController.text);
                            transaccion.tipoTransaccion = new BETipoTransaccion(idTipoTransaccion: _cmbTipoTransaccion.idTipoTransaccion);
                            transaccion.fechaDocumento = _fecha;
                            DBProvider.db.guardarTransaccion(transaccion);
                            Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
