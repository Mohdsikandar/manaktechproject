import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/Itemmodel.dart';

class Databasehandler{

  Future<Database> initializedb()async{

    String path = await getDatabasesPath();

    return openDatabase(
      join(path,'exampl.db'),
      onCreate:(database,version)async{
        await database.execute(
          "CREATE TABLE productdb(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price TEXT, qty TEXT, image TEXT)",
        );
      },
      version: 1
    );

  }

  Future<int> insertUser(List<productdb> users) async {
    int result = 0;
    final Database db = await initializedb();
    for(var user in users){
      result = await db.insert('productdb', user.toMap());
    }
    return result;
  }

  Future<List<productdb>> retrieveUsers() async {
    final Database db = await initializedb();
    final List<Map<String, Object?>> queryResult = await db.query('productdb');
    return queryResult.map((e) => productdb.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await initializedb();
    await db.delete(
      'productdb',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}