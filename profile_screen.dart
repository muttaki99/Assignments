import 'dart:convert';

import 'package:assingments/Data/Controller/auth_controller.dart';
import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Models/user_model.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:assingments/Widgets/tm_appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool inProgress = false;

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passTEController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  XFile? selectedImage;
  @override
  void initState() {
    super.initState();
    setUserData();
  }

  void setUserData(){
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _phoneTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32,),
                Text('Update Profile',style:
                Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:
                FontWeight.bold),),
                SizedBox(height: 24,),
                buildPhotoAddContainer(),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Email'
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: InputDecoration(
                      hintText: 'First Name'
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: InputDecoration(
                      hintText: 'Last Name'
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _phoneTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Mobile'
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _passTEController,
                  decoration: InputDecoration(
                      hintText: 'Password'
                  ),
                ),
                SizedBox(height: 32,),
                Visibility(
                  visible: !inProgress,
                  replacement: Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                      onPressed: (){
                        if(_keyForm.currentState!.validate()){
                          _profileUpdate();
                        }
                      }, child:
                  Icon(Icons.arrow_circle_right_outlined)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhotoAddContainer() => GestureDetector(
    onTap: _selectImage,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
            ),
            alignment: Alignment.center,
            child: Text('Photo',style:
            TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          ),
          SizedBox(width: 16,),
          Text(selectPhotoTitle(),style:
          TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),)
        ],
      ),
    ),
  );

  String selectPhotoTitle(){
    if(selectedImage != null){
      selectedImage!.name;
    }
    return 'Select photo';
  }


  Future<void> _selectImage()async{
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      selectedImage = pickedImage;
      setState(() {});
    }
  }

  Future <void> _profileUpdate() async{
    inProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile": _phoneTEController.text.trim(),
    };

    if(_passTEController.text.isNotEmpty){
      requestBody["password"] = _passTEController.text;
    }

    if(selectedImage != null){
      List<int> imageByte = await selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageByte);
      requestBody['photo'] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.profileUpdate,body: requestBody);

    inProgress = false;
    setState(() {});

    if(response.isSuccess){
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBar(context, 'Profile Update Successfully');
    }else{
      showSnackBar(context, response.errorMessage);
    }

  }

}
