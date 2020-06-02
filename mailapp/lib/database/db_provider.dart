import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mailapp/models/mail.dart';

class DbProvider {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  Future<int> createMail(Mail mail) async {
    final db = await database;
    return await db.insert('Mail', mail.toMap());
  }

  Future<List<Mail>> getAllMails() async {
    final db = await database;
    var res = await db.query('Mail');
    List<Mail> list =
        res.isNotEmpty ? res.map((a) => Mail.fromMap(a)).toList() : [];
    return list;
  }

  Future deleteMail(Mail mail) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('Mail', where: "id = ?", whereArgs: [mail.id]);
    });
  }

  Future<int> updateFav(Mail mail) async{
    final db= await database;
    var x=await db.update('Mail', mail.toMap(), where: 'id=?', whereArgs: [mail.id]);
    return x;
  }

  void dispose() {
    _database?.close();
    _database = null;
  }

  Future<Database> initialize() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'spend_tracker.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {
        print('Database Open');
      },
      onCreate: _onCreate,
    );

    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE "Mail" ("id" INTEGER PRIMARY KEY NOT NULL ,"to" TEXT,"from" TEXT,"date" TEXT,"subject" TEXT,"description" TEXT,"isFavourite" INTEGER)');
  }
}
