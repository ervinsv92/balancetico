
import 'package:balancetico/pages/balance_rango_grupo_page.dart';
import 'package:flutter/material.dart';
import 'package:balancetico/pages/balance_categoria_page.dart';
import 'package:balancetico/pages/balance_diario_page.dart';
import 'package:balancetico/pages/balance_rango_page.dart';
import 'package:balancetico/pages/lista_categorias_page.dart';
import 'package:balancetico/pages/registro_categoria_page.dart';
import 'package:balancetico/pages/registro_transacciones_page.dart';

class Routes{
  static final String balanceDiario = "balance_diario";
  static final String balanceRango = "balance_rango";
  static final String balanceRangoGrupo = "balance_rango_grupo";
  static final String balanceCategoria = "balance_categoria";
  static final String registroCategoria = "registro_categoria";
  static final String listaCategoria = "lista_categorias";
  static final String registroTransacciones = "registro_transacciones";
}

Map<String, WidgetBuilder> getApplicationRoutes() {

  return <String, WidgetBuilder> {
      Routes.balanceDiario         : ( BuildContext context ) => BalanceDiarioPage(),
      Routes.balanceRango          : ( BuildContext context ) => BalanceRangoPage(),
      Routes.balanceRangoGrupo     : ( BuildContext context ) => BalanceRangoGrupoPage(),
      Routes.balanceCategoria      : ( BuildContext context ) => BalanceCategoriaPage(),
      Routes.registroCategoria     : ( BuildContext context ) => RegistroCategoriaPage(),
      Routes.listaCategoria        : ( BuildContext context ) => ListaCategoriasPage(),
      Routes.registroTransacciones : ( BuildContext context ) => RegistroTransaccionesPage(),
  };

}