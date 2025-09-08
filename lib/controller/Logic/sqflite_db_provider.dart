// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

class SqlDB {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDB();
      return _db;
    }
    return _db;
  }

  Future<Database?> initDB() async {
    String? databasePath;
    Directory? dbpath;
    String? path;
    Database? mydb;
    if (Platform.isWindows) {
      sqfliteFfiInit();
      DatabaseFactory databaseFactory = databaseFactoryFfi;
      dbpath = await getApplicationDocumentsDirectory();
      path = join(dbpath.path, "Notebook.db");
      mydb = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(version: 3, onCreate: onCreate));
      return mydb;
    } else {
      databasePath = await getDatabasesPath();
      path = join(databasePath, "Notesbook.db");
      mydb = await openDatabase(path, onCreate: onCreate, version: 3);
      return mydb;
    }
  }

  Future onCreate(Database? db, int version) async {
    await db!.execute('''
 CREATE TABLE `notes`(
  noteId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , 
  noteTitle TEXT NOT NULL ,
  noteContent TEXT NOT NULL ,
  contentType TEXT NOT NULL , 
  contentIndex int(2) NOT NULL , 
  noteImageUrl TEXT  DEFAULT 'assets/note_book.jpeg' ,
  noteColor INTEGER DEFAULT 4292332503 , 
  contentSize double NOT NULL , 
  noteTime TEXT NOT NULL , 
  noteDate TEXT NOT NULL  , 
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fontStyle TEXT NOT NULL , 
  fontWeight TEXT NOT NULL 
  ) 
''');
  }

  Future<List<Map<String, Object?>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, Object?>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<void> myDeleteDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "Notebook.db");
    await deleteDatabase(path);
  }
}
