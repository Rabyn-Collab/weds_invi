import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DBHelper{

  static Future<Database> database() async{
    final dbPath = await getDatabasesPath();

    return openDatabase(join(dbPath, 'guests.db'), onCreate: (db, version){
      return db.execute('CREATE TABLE user_guests(id TEXT PRIMARY KEY, name TEXT, address TEXT, phone TEXT, visiting INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async{

    final db = await DBHelper.database();

    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);

  }

  static Future<List<Map<String, dynamic>>> getData(String table) async{

    final db = await DBHelper.database();

    return db.query(table);

  }


  static Future<int> updateData(String table, Map<String, Object> data) async{

    final db = await DBHelper.database();
    return db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);

  }

  static Future<int> removeData(String table, String id) async{

    final db = await DBHelper.database();
    return db.delete(table, where: 'id = ?', whereArgs: [id]);

  }


}