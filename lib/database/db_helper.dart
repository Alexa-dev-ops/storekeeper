import 'dart:async';
import 'dart:developer' as developer;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  // Add this static getter so you can use DatabaseHelper.instance
  static DatabaseHelper get instance => _instance;

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

  Future<int> createProduct(Product product) async {
    try {
      final db = await database;
      final id = await db.insert('products', product.toMap());
      return id;
    } catch (e) {
      developer.log('Error saving product: $e');
      rethrow;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final db = await database;
      if (!db.isOpen) {
        throw Exception('Database is not open');
      }
      final result = await db.query('products', orderBy: 'addedOn DESC');
      return result.map((e) => Product.fromMap(e)).toList();
    } catch (e) {
      developer.log('Error fetching all products: $e');
      rethrow;
    }
  }

  Future<Product?> getProduct(int id) async {
    try {
      final db = await database;
      if (!db.isOpen) {
        throw Exception('Database is not open');
      }
      if (id <= 0) {
        throw ArgumentError('Invalid product ID');
      }
      final result = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty ? Product.fromMap(result.first) : null;
    } catch (e) {
      developer.log('Error fetching product with id $id: $e');
      rethrow;
    }
  }

  Future<int> updateProduct(Product product) async {
    try {
      final db = await database;
      return await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      developer.log('Error updating product: $e');
      rethrow;
    }
  }

  Future<int> deleteProduct(int id) async {
    try {
      final db = await database;
      return await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      developer.log('Error deleting product: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
