import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:assingments/Widgets/tm_appbar.dart';
import 'package:flutter/material.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  bool _inProgress = false;
  bool _refreshPage = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        Navigator.pop(context, _refreshPage);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TMAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      SizedBox(height: 52,),
                      Text('Add a new task',style:
                      TextStyle( fontSize:24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 28,),
                      TextFormField(
                        controller: _titleTEController,
                        decoration: InputDecoration(
                            hintText: 'Title'
                        ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter a Title ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12,),
                      TextFormField(
                        controller: _descriptionTEController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: 'Description'
                        ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter a Description ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 38,),
                      Visibility(
                        visible: !_inProgress,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                            onPressed: _onTabNextBtnScreen, child:
                        Icon(Icons.arrow_circle_right_outlined)),
                      ),
                    ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTabNextBtnScreen() {
    if(_keyForm.currentState!.validate()){
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async{
    _inProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody ={
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status":"New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.addNewTask, body: requestBody);

    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
      _clearTaskField();
      showSnackBar(context, 'New Task Added!');
    }else{
      showSnackBar(context, response.errorMessage);
    }
  }

  void _clearTaskField(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

}
