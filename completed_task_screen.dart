import 'package:assingments/Data/Models/task_list_model.dart';
import 'package:assingments/Data/Models/task_model.dart';
import 'package:assingments/Screen/task_card.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../Data/Models/network_response.dart';
import '../Data/Service/network_caller.dart';
import '../Data/Urls/urls.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  bool inProgressTaskList = false;
  List<TaskList> completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Visibility(
        visible: !inProgressTaskList,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
          child: ListView.separated(
            itemCount: 5,
            itemBuilder: (context, index){
              return TaskDetailsCard(
                taskList: completedTaskList[index],
                onRefresh: _getCompletedTaskList,
              );
            },
            separatorBuilder: (context, index){
              return SizedBox(height: 8,);
            },
          ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    completedTaskList.clear();
    inProgressTaskList = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.addCompleteTaskList);

    inProgressTaskList= false;
    setState(() {});
    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      completedTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBar(context, response.errorMessage);
    }
    setState(() => inProgressTaskList = false);
  }
}
