import 'package:assingments/Data/Models/task_model.dart';

class TaskListModel {
  String? status;
  List<TaskList>? taskList;

  TaskListModel({this.status, this.taskList});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskList = <TaskList>[];
      json['data'].forEach((v) {
        taskList!.add(TaskList.fromJson(v));
      });
    }
  }
}

