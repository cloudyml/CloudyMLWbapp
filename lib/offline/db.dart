import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'offline.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE offline(id INTEGER PRIMARY KEY AUTOINCREMENT, topic TEXT, module TEXT,course TEXT,path TEXT )");

        //return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(OfflineModel video) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('offline', video.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<List<OfflineModel>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('offline');
    return List.generate(taskMap.length, (index) {
      return OfflineModel(
        id: taskMap[index]['id'],
        topic: taskMap[index]['topic'],
        module: taskMap[index]['module'],
        course: taskMap[index]['course'],
        path: taskMap[index]['path'],
      );
    });
  }
}
