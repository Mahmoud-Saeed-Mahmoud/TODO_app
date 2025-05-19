import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelper.insert(task);
  }

  deleteTasks({required Task task}) async {
    await DBHelper.delete(task);
    getTasks();
  }

  getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();

    taskList.assignAll(tasks.map((json) => Task.fromJson(json)).toList());
  }

  markTaskAsCompleted({required int id}) async {
    await DBHelper.update(id);
    getTasks();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
