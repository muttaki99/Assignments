import 'package:assingments/Data/Models/task_status_model.dart';

class TaskStatusCount {
  String? status;
  List<TaskStatusCountModel>? taskStatusCountList;

  TaskStatusCount({this.status, this.taskStatusCountList});

  TaskStatusCount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCountList = <TaskStatusCountModel>[];
      json['data'].forEach((v) {
        taskStatusCountList!.add(TaskStatusCountModel.fromJson(v));
      });
    }
  }
}
