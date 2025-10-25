import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart_item.dart';

class CartService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart_items(
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            product_id TEXT NOT NULL,
            title TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            image_url TEXT NOT NULL,
            size TEXT,
            color TEXT
          )
        ''');
      },
    );
  }

  // Insert cart item for a specific user
  Future<void> insertCartItem(String userId, CartItem item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      {
        ...item.toMap(),
        'user_id': userId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update cart item for a specific user
  Future<void> updateCartItem(String userId, CartItem item) async {
    final db = await database;
    await db.update(
      'cart_items',
      {
        ...item.toMap(),
        'user_id': userId,
      },
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, item.productId],
    );
  }

  // Delete cart item for a specific user
  Future<void> deleteCartItem(String userId, String productId) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  // Get all cart items for a specific user
  Future<List<CartItem>> getCartItems(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return CartItem.fromMap(maps[i]);
    });
  }

  // Clear all cart items for a specific user
  Future<void> clearCart(String userId) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}

