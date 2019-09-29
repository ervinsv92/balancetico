
import 'package:flutter/material.dart';
import 'package:balancetico/routes/routes.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFF689F38),
      accentColor: Color(0xFF03A9F4),
    ),
    initialRoute: 'balance_diario',
    routes: getApplicationRoutes(),
  )
);