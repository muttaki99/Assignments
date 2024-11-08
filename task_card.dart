import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Models/task_model.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/material.dart';

class TaskDetailsCard extends StatefulWidget {
  const TaskDetailsCard({
    super.key, required this.taskList,
    required this.onRefresh,
  });

  final TaskList taskList;
  final VoidCallback onRefresh;

  @override
  State<TaskDetailsCard> createState() => _TaskDetailsCardState();
}

class _TaskDetailsCardState extends State<TaskDetailsCard> {

  String selectedTaskStatus = '';
  bool _inProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  void initState() {
    super.initState();
    selectedTaskStatus = widget.taskList.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child:
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskList.title ?? '',style: TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold),),
            Text(widget.taskList.description ?? '',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Date: ${widget.taskList.createdDate}',style: TextStyle(fontSize: 15),),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTaskChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: !_inProgress,
                      replacement: Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: IconButton(onPressed: _editBtn, icon: Icon(
                        Icons.edit,color: Colors.green.shade500,)),
                    ),
                    Visibility(
                      visible: !_deleteTaskInProgress,
                      replacement: Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: IconButton(onPressed: _deleteTaskListBtn, icon: Icon(
                        Icons.delete_outline,color: Colors.red.shade500,)),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTaskListBtn() async {
    _deleteTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(widget.taskList.sId!));
    if(response.isSuccess){
      widget.onRefresh;
    }else{
      _deleteTaskInProgress = false;
      setState(() {});
      showSnackBar(context, response.errorMessage);
    }
  }
  
  void _editBtn(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Edit Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['New','Completed','Cancelled','Progress'].map((e){
            return ListTile(
              onTap: (){
                _changeStatus(e);
                Navigator.pop(context);
              },
              title: Text(e),
              selected: selectedTaskStatus == e,
              trailing: selectedTaskStatus == e? Icon(Icons.check):null,
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: (){}, child: Text('Okay')),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
        ],
      );
    });
  }

  Widget _buildTaskChip() {
    return Chip(label: Text(widget.taskList.status!,style: TextStyle(
        fontSize: 12,fontWeight: FontWeight.bold),), 
      side: BorderSide(
        color: Colors.green.shade500,
      ),
     );
    }

    Future<void> _changeStatus(String status) async{
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.selectTaskStatus(widget.taskList.sId!, status));
    if(response.isSuccess){
      widget.onRefresh;
    }else{
      _inProgress = false;
      setState(() {});
      showSnackBar(context, response.errorMessage);
    }
    }

  }