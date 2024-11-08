import 'package:assingments/Data/Models/task_model.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Screen/task_card.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../Data/Models/network_response.dart';
import '../Data/Models/task_list_model.dart';
import '../Data/Service/network_caller.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  bool inProgressTaskList = false;
  List<TaskList> cancelledTaskList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index){
          return TaskDetailsCard(
            taskList: cancelledTaskList[index],
            onRefresh: _getCancelledTaskList,
          );
        },
        separatorBuilder: (context, index){
          return SizedBox(height: 8,);
        },
      ),
    );
  }

  Future<void> _getCancelledTaskList() async {
    cancelledTaskList.clear();
    setState(() => inProgressTaskList = true);

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.addCancelTaskList);
    inProgressTaskList = false;
    setState(() {});
    if (response.isSuccess) {
      final taskListModel = TaskListModel.fromJson(response.responseData);
      cancelledTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBar(context, response.errorMessage);
    }
    setState(() => inProgressTaskList = false);
  }

}
