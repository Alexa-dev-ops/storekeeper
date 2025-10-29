import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('storekeeper.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final pathToDb = path.join(dbPath, filePath);

    return await openDatabase(pathToDb, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        imagePath TEXT,
        addedOn TEXT NOT NULL
      )
    ''');
  }

  // Create product
  Future<int> createProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  // Read all the products
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products', orderBy: 'addedOn DESC');
    return result.map((e) => Product.fromMap(e)).toList();
  }

  // Read by ID Number
  Future<Product?> getProduct(int id) async {
    final db = await database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  // Update the product
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete product
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
