import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/exercise.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'exercise.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE exercise (id INTEGER PRIMARY KEY,name TEXT,time INTEGER)''');
  }

  Future<List<Exercise>> getExercise() async {
    Database db = await instance.database;
    var exercise = await db.query('exercise', orderBy: 'id');
    List<Exercise> exerciseList = exercise.isNotEmpty
        ? exercise.map((e) => Exercise.fromMap(e)).toList()
        : [];
    return exerciseList;
  }

  Future<int> add(Exercise exercise) async {
    Database db = await instance.database;
    return await db.insert('exercise', exercise.toMap());
  }

  Future<int> update(Exercise exercise) async {
    Database db = await instance.database;
    return await db.update('exercise', exercise.toMap(),
        where: 'id=?', whereArgs: [exercise.id]);
  }
}
