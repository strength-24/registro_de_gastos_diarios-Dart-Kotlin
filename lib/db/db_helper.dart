import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/transaccion.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'finanzas.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transacciones (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion TEXT,
            monto REAL,
            tipo TEXT,
            fecha TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertarTransaccion(Transaccion t) async {
    final base = await db;
    return await base.insert('transacciones', t.toMap());
  }

  Future<int> actualizarTransaccion(Transaccion t) async {
    final base = await db;
    return await base.update(
      'transacciones',
      t.toMap(),
      where: 'id = ?',
      whereArgs: [t.id],
    );
  }

  Future<int> eliminarTransaccion(int id) async {
    final base = await db;
    return await base.delete('transacciones', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Transaccion>> obtenerTransacciones() async {
    final base = await db;
    final res = await base.query('transacciones');
    return res.map((e) => Transaccion.fromMap(e)).toList();
  }
}
