import 'package:letsdoapp/Models/Task.dart';
import 'package:letsdoapp/Models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async{
        // Run the CREATE TABLE statement on the database.
        await db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',);
        await db.execute('CREATE TABLE todo(id INTEGER PRIMARY KEY,taskId INTEGER, title TEXT, isDone INTEGER)',);
        return Future.value();
      },
      version: 1,
    );
  }
  Future<void> updatetasktitle(int id, String title) async {
    Database _db = await database();
    await _db.rawQuery("UPDATE tasks SET title = '$title' WHERE id='$id'");
  }
  Future<void> updatetaskdesc(int id, String desc) async {
    Database _db = await database();
    await _db.rawQuery("UPDATE tasks SET description = '$desc' WHERE id='$id'");
  }

  Future<int> insertTask(Task task) async {
    int taskId =0;
    Database _db = await database();
    await _db.insert("tasks", task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value){
      taskId = value;
    });
    return taskId;
  }
  Future<void> insertTodo(todo todo) async {
    Database _db = await database();
    await _db.insert("todo", todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'], title: taskMap[index]['title'], description: taskMap[index]['description']);
    });
  }
    Future<List<todo>> getTodo(int taskId) async {
      Database _db = await database();
      List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
      return List.generate(todoMap.length, (index) {
        return todo(id: todoMap[index]['id'], title: todoMap[index]['title'], taskId: todoMap[index]['taskId'],isDone: todoMap[index]['isDone']);
      });
  }
  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawQuery("UPDATE todo SET isDone = '$isDone' WHERE id='$id'");
  }
  Future<void> deletetask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE from tasks WHERE id='$id'");
    await _db.rawDelete("DELETE from todo WHERE Taskid='$id'");
  }
}
