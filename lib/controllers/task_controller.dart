import 'package:get/get.dart';


import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  //this will hold the data and update the ui

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final taskList = <Task>[].obs;

  // add data to table
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  Future<int?> updateTask({Task? task})async{
    return await DBHelper.updateTask(task);
  }


  Future getTask(int id)async{
    return DBHelper.getTask(id);
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  // delete data from table
  Future deleteTask(Task task)async{
    await DBHelper.deleteTask(task);
    getTasks();
  }

  // update data int table
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  // Future updateTaskStatus(int id)async{
  //   await SqlServices.updateTaskStatus(id);
  //   getTasks();
  // }
}
