import 'package:advanced_todo_app/db/db_helper.dart';
import 'package:get/get.dart';

import '../modules/task.dart';

class TaskController extends GetxController {
  RxList Tasks = [].obs;

  addTask(Task? task) async {
    return DbHelper.insert(task);
    // getTasks();
  }

  getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    Tasks.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  deleteTask(Task task) async {
    await DbHelper.delete(task);
    getTasks();
  }

  updateTask(int id) async {
    await DbHelper.update(id);
    getTasks();
  }

   deleteAll() async {
    await DbHelper.deleteAll();
    getTasks();
  }
}
