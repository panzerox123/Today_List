import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Holder {
  String title;
  String taskList;
  String summaryList;
  String color;
  Holder(this.title,this.taskList,this.summaryList,this.color);
}

class DbHelper {
  Database _db;
  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'holder_database.db');
    var newDb = openDatabase(path, version: 1, onCreate: _onCreate);
    return newDb;
  }

  _onCreate(Database db, version) async {
    await db.execute("CREATE TABLE Holder(id INTEGER PRIMARY KEY, title TEXT, tasklist TEXT, summarylist TEXT, color TEXT)");
    print("Created new Database");
  }

  Future<List<Holder>> getTitle() async {
    var dbClient = await db;
    List<Map> temp_list = await dbClient.rawQuery('SELECT * FROM Holder');
    List<Holder> newList = new List();
    for (int i = 0; i < temp_list.length; i++) {
      newList.add(Holder(temp_list[i]['title'], temp_list[i]['tasklist'], temp_list[i]['summarylist'], temp_list[i]['color']));
    }
    print("Received Database  . . . Holder");
    return newList;
  }

  void saveTitle(Holder saveTitle) async {
    var dbClient = await db;
    dbClient.transaction((txn) {
      dbClient.rawInsert('INSERT INTO Holder(title, tasklist, summarylist, color) VALUES(' +
          '\'' +
          saveTitle.title +
          '\'' +
          ',' +
          '\'' +
          saveTitle.taskList +
          '\'' +
          ',' +
          '\'' +
          saveTitle.summaryList +
          '\'' +
          ','+
          '\'' +
          saveTitle.color +
          '\'' +
          ')'
        );
    });
    print("Saved Successfully . . . Holder");
  }

  Future<int> deleteList(String title) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM Holder WHERE title ='+ '\'' + title + '\'');
  }

  Future<int> updateItem(String title,String task,String summary) async{
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE Holder SET tasklist=\'$task\',summarylist=\'$summary\' WHERE title=\'$title\'');
  }

  Future<int> updateCurrList(String title, String task,String summary, String color) async{
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE Holder SET tasklist=\'$task\',summarylist=\'$summary\',color=\'$color\' WHERE title=\'$title\'');
  }
}
