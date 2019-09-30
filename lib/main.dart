
import 'package:flutter/material.dart';
import 'package:balancetico/routes/routes.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFF8BC34A),
      accentColor: Color(0xFFFF5722),
      primaryColorDark: Color(0xFF689F38),
      primaryColorLight: Color(0xFFDCEDC8)
    ),
    initialRoute: 'balance_diario',
    routes: getApplicationRoutes(),
  )
);