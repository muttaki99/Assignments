import 'package:assingments/Data/Models/task_model.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Screen/task_card.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../Data/Models/network_response.dart';
import '../Data/Models/task_list_model.dart';
import '../Data/Service/network_caller.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  bool inProgressTaskList = false;
  List<TaskList> progressTaskList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index){
          return TaskDetailsCard(
            taskList: progressTaskList[index],
            onRefresh: _getProgressTaskList,
          );
        },
        separatorBuilder: (context, index){
          return SizedBox(height: 8,);
        },
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    progressTaskList.clear();
    setState(() => inProgressTaskList = true);

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.addProgressTaskList);
    inProgressTaskList = false;
    setState(() {});
    if (response.isSuccess) {
      final taskListModel = TaskListModel.fromJson(response.responseData);
      progressTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBar(context, response.errorMessage);
    }
    setState(() => inProgressTaskList = false);
  }
  
}
