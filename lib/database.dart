import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sample/dataModel.dart';

class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "MyDB5.db"),
      onCreate: (database, version) async {
        await database.execute(
            """CREATE TABLE MyTable3(id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age TEXT NOT NULL,
            school TEXT NOT NULL,
            standerd TEXT NOT NULL,image TEXT)""");
      },
      version: 1,
    );
  }

  Future<bool> insertData(DataModel dataModel) async {
    final Database db = await initDB();
    db.insert("MyTable3", dataModel.toMap());
    return true;
  }

  Future<List<DataModel>> getData() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.query("MyTable3");
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }

  Future<void> update(DataModel dataModel, int id) async {
    final Database db = await initDB();
    await db
        .update('MyTable3', dataModel.toMap(), where: "id=?", whereArgs: [id]);
  }

  Future<void> delete(int? id) async {
    final Database db = await initDB();
    await db.delete('MyTable3', where: "id=?", whereArgs: [id]);
  }

  Future<List<DataModel>> searchdata(String keyword) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> result =
        await db.query("MyTable3", where: "name=?", whereArgs: [keyword]);
    return result.map((e) => DataModel.fromMap(e)).toList();
  }
}
