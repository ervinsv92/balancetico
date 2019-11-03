import 'package:balancetico/models/BETipoTransaccion.dart';
import 'package:balancetico/providers/db_provider.dart';
import 'package:flutter/material.dart';

class RegistroTransaccionesPage extends StatefulWidget {
  RegistroTransaccionesPage({Key key}) : super(key: key);

  _RegistroTransaccionesPageState createState() =>
      _RegistroTransaccionesPageState();
}

class _RegistroTransaccionesPageState extends State<RegistroTransaccionesPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _txtMontoController = TextEditingController();
  String _titulo = "Registro transacción";
  BETipoTransaccion _cmbTipoTransaccion;
  List<BETipoTransaccion> _listaTipoTransaccion;
  //Furure<BETipoTransaccion> fuTipoTransaccion;
  //BETransaccion _transaccion = new BETransaccion();

  @override
  void initState() {
    super.initState();
    _obtenerTiposTransaccionPorTipo();
  }

  void _obtenerTiposTransaccionPorTipo() async {
    _listaTipoTransaccion =
        await DBProvider.db.obtenerTiposTransaccionPorTipo("I");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                    if (value.isEmpty || value.trim() == "") {
                      return "Debe digitar una categoría";
                    }
                  },
                  controller: _txtMontoController,
                ),
                Divider(
                  height: 10.0,
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
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
