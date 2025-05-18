import 'package:flutter/material.dart';
import 'pantallas/pantalla_agregar.dart';
import 'pantallas/pantalla_resumen.dart';

void main() {
  runApp(const ControlFinancieroApp());
}

class ControlFinancieroApp extends StatelessWidget {
  const ControlFinancieroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Financiero',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const PantallaResumen(),
    );
  }
}
