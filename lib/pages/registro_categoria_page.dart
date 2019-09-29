import 'package:flutter/material.dart';

class RegistroCategoriaPage extends StatefulWidget {
  RegistroCategoriaPage({Key key}) : super(key: key);

  _RegistroCategoriaPageState createState() => _RegistroCategoriaPageState();
}

class _RegistroCategoriaPageState extends State<RegistroCategoriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Categoria"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Nombre Categoria"),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.lightGreen,
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  child: Text("Guardar", style: TextStyle(fontSize: 20.0)),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
