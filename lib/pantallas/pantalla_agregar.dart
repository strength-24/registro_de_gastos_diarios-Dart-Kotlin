import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../modelos/transaccion.dart';

class PantallaAgregar extends StatefulWidget {
  const PantallaAgregar({super.key});

  @override
  State<PantallaAgregar> createState() => _PantallaAgregarState();
}

class _PantallaAgregarState extends State<PantallaAgregar> {
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  String _tipo = 'gasto';

  void _guardar() async {
    if (_descripcionController.text.isEmpty || _montoController.text.isEmpty) return;

    final transaccion = Transaccion(
      descripcion: _descripcionController.text,
      monto: double.tryParse(_montoController.text) ?? 0.0,
      tipo: _tipo,
      fecha: DateTime.now().toIso8601String(),
    );

    await DBHelper().insertarTransaccion(transaccion);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Transacción')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto'),
            ),
            DropdownButton<String>(
              value: _tipo,
              items: const [
                DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
                DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
              ],
              onChanged: (val) {
                setState(() {
                  _tipo = val!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
