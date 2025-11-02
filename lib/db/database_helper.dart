import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoDados {
  static final BancoDados instance = BancoDados._init();
  static Database? _database;

  BancoDados._init();

  // Inicialização do banco
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('travel_planner.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await _createDB(db, newV);
        }
      },
    );
  }

  // Criação das tabelas
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS economias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        valor REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria TEXT NOT NULL,
        descricao TEXT NOT NULL,
        valor REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS transportes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meio TEXT NOT NULL,
        custo REAL NOT NULL,
        tempo TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS roteiros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local TEXT NOT NULL,
        data TEXT NOT NULL,
        descricao TEXT NOT NULL
      )
    ''');
  }

  // ==========================
  // ===== ECONOMIAS =========
  // ==========================
  Future<int> inserirEconomia(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('economias', data);
  }

  Future<List<Map<String, dynamic>>> buscarEconomias() async {
    final db = await instance.database;
    return await db.query('economias', orderBy: 'id DESC');
  }

  Future<int> deletarEconomia(int id) async {
    final db = await instance.database;
    return await db.delete('economias', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================
  // ===== GASTOS =============
  // ==========================
  Future<int> inserirGasto(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('gastos', data);
  }

  Future<List<Map<String, dynamic>>> buscarGastos() async {
    final db = await instance.database;
    return await db.query('gastos', orderBy: 'id DESC');
  }

  Future<int> deletarGasto(int id) async {
    final db = await instance.database;
    return await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================
  // ===== TRANSPORTES ========
  // ==========================
  Future<int> inserirTransporte(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('transportes', data);
  }

  Future<List<Map<String, dynamic>>> buscarTransportes() async {
    final db = await instance.database;
    return await db.query('transportes', orderBy: 'id DESC');
  }

  Future<int> deletarTransporte(int id) async {
    final db = await instance.database;
    return await db.delete('transportes', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================
  // ===== ROTEIROS ===========
  // ==========================
  Future<int> inserirRoteiro(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('roteiros', data);
  }

  Future<List<Map<String, dynamic>>> buscarRoteiros() async {
    final db = await instance.database;
    return await db.query('roteiros', orderBy: 'id ASC');
  }

  Future<int> deletarRoteiro(int id) async {
    final db = await instance.database;
    return await db.delete('roteiros', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================
  // ===== LIMPAR TUDO ========
  // ==========================
  Future<void> limparTudo() async {
    final db = await instance.database;
    await db.delete('economias');
    await db.delete('gastos');
    await db.delete('transportes');
    await db.delete('roteiros');
  }

  // Fechar banco (opcional)
  Future<void> fechar() async {
    final db = await instance.database;
    await db.close();
  }
}
