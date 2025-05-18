import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../modelos/transaccion.dart';
import 'pantalla_agregar.dart';

class PantallaResumen extends StatefulWidget {
  const PantallaResumen({super.key});

  @override
  State<PantallaResumen> createState() => _PantallaResumenState();
}

class _PantallaResumenState extends State<PantallaResumen> {
  List<Transaccion> _transacciones = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final datos = await DBHelper().obtenerTransacciones();
    setState(() {
      _transacciones = datos;
    });
  }

  double get _totalGastos =>
      _transacciones.where((t) => t.tipo == 'gasto').fold(0.0, (s, t) => s + t.monto);

  double get _totalIngresos =>
      _transacciones.where((t) => t.tipo == 'ingreso').fold(0.0, (s, t) => s + t.monto);

  void _eliminar(int id) async {
    await DBHelper().eliminarTransaccion(id);
    _cargar();
  }

  void _editar(Transaccion transaccion) async {
    final descripcion = TextEditingController(text: transaccion.descripcion);
    final monto = TextEditingController(text: transaccion.monto.toString());
    String tipo = transaccion.tipo;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Transacción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: descripcion, decoration: const InputDecoration(labelText: 'Descripción')),
            TextField(controller: monto, decoration: const InputDecoration(labelText: 'Monto')),
            DropdownButton<String>(
              value: tipo,
              items: const [
                DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
                DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
              ],
              onChanged: (val) => tipo = val!,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final nueva = Transaccion(
                id: transaccion.id,
                descripcion: descripcion.text,
                monto: double.tryParse(monto.text) ?? 0.0,
                tipo: tipo,
                fecha: transaccion.fecha,
              );
              await DBHelper().actualizarTransaccion(nueva);
              Navigator.pop(context);
              _cargar();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saldo = _totalIngresos - _totalGastos;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen Financiero')),
      body: Column(
        children: [
          ListTile(title: const Text('Total Ingresos'), trailing: Text('\$${_totalIngresos.toStringAsFixed(2)}')),
          ListTile(title: const Text('Total Gastos'), trailing: Text('\$${_totalGastos.toStringAsFixed(2)}')),
          ListTile(
            title: const Text('Saldo Disponible', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text('\$${saldo.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: saldo >= 0 ? Colors.green : Colors.red)),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _transacciones.length,
              itemBuilder: (_, i) {
                final t = _transacciones[i];
                return ListTile(
                  title: Text(t.descripcion),
                  subtitle: Text('${t.tipo} - ${t.fecha.substring(0, 10)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${t.monto.toStringAsFixed(2)}'),
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editar(t)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _eliminar(t.id!)),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final actualizado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PantallaAgregar()),
          );
          if (actualizado == true) _cargar();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
