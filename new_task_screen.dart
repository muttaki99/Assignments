import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Models/task_list_model.dart';
import 'package:assingments/Data/Models/task_model.dart';
import 'package:assingments/Data/Models/task_status_count.dart';
import 'package:assingments/Data/Models/task_status_model.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Screen/add_new_task_screen.dart';
import 'package:assingments/Screen/task_card.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../Widgets/card_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key,});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _taskListInProgress = false;
  bool _taskListCountInProgress = false;
  List<TaskList> _newTaskList = [];
  List<TaskStatusCountModel> _newTaskListCount = [];

  @override
  void initState() {
    super.initState();
    _getTaskList();
    _getTaskStatusCountList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          _getTaskList();
          _getTaskStatusCountList();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskSummerySection(),
            Expanded(
                  child: Visibility(
                    visible: !_taskListInProgress,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.separated(
                      itemCount: _newTaskList.length,
                      itemBuilder: (context, index){
                        return TaskDetailsCard(
                          taskList: _newTaskList[index],
                          onRefresh: _getTaskList,
                        );
                      },
                      separatorBuilder: (context, index){
                        return SizedBox(height: 8,);
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: onTabAddTaskBtn,
          child: Icon(Icons.edit)),
    );
  }

  Future<void> onTabAddTaskBtn() async{
    final bool? shouldRefresh = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddNewTaskScreen(),
        ),
    );
    if(shouldRefresh == true){
      _getTaskList();
    }
  }

  Widget _taskSummerySection() {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: !_taskListCountInProgress,
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: _getTaskSummaryCardList(),
                    ),
                ),
              ),
            );
  }

  List<TaskSummeryCard> _getTaskSummaryCardList(){
    List<TaskSummeryCard> taskSummeryCardList = [];
    for(TaskStatusCountModel t in _newTaskListCount){
      taskSummeryCardList.add(TaskSummeryCard(count: t.sum!, title: t.sId!));
    }
    return taskSummeryCardList;
  }

  Future<void> _getTaskList() async{
    _newTaskList.clear();
    _taskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.addNewTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(
          response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    }else{
      showSnackBar(context, response.errorMessage);
    }
    _taskListInProgress = false;
    setState(() {});
  }

  Future<void> _getTaskStatusCountList() async{
    _newTaskListCount.clear();
    _taskListCountInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskStatusCount);
    if(response.isSuccess){
      final TaskStatusCount taskStatusCount = TaskStatusCount.fromJson(
          response.responseData);
      _newTaskListCount = taskStatusCount.taskStatusCountList ?? [];
    }else{
      showSnackBar(context, response.errorMessage);
    }
    _taskListCountInProgress = false;
    setState(() {});
  }
}
