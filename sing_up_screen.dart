import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Utils/app_color.dart';
import 'package:assingments/Widgets/background_screen.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundScreen(child:
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                      SizedBox(height: 42,),
                      Text('Join With Us.',style:
                      textTheme.headlineMedium?.copyWith(fontWeight:
                      FontWeight.bold),),
                      SizedBox(height: 24,),
                      buildSingUpForm(),
                      SizedBox(height: 32,),

               Center(
                child: Column(
                  children: [
                    buildSingInSection(),
                  ]
                )
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget buildSingInSection() {
    return RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            text: "Have an account?  ",
            children: [
              TextSpan(
                text: 'Sing In',style: TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap = _onTabSingInScreen
              )
            ]
        )
    );
  }

  void _onTabSingInScreen(){
    Navigator.pop(context);
  }

  Widget buildSingUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'Email'
            ),
            validator: (String? value){
              if(value?.isEmpty == true){
                return 'Enter a valid email';
              }else if(!value!.contains('@')){
                return "Enter a valid email with '@'";
              }else if(!value.contains('.com')){
                return "Enter a valid email with '.com'";
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _firstNameTEController,
            decoration: InputDecoration(
                hintText: 'First Name'
            ),
            validator: (String? value){
              if(value?.isEmpty == true){
                return 'Enter First Name';
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _lastNameTEController,
            decoration: InputDecoration(
                hintText: 'Last Name'
            ),
            validator: (String? value){
              if(value?.isEmpty == true){
                return 'Enter Last Name';
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _mobileTEController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: 'Mobile'
            ),
            validator: (String? value){
              if(value?.isEmpty == true){
                return 'Enter a valid Mobile Number';
              }
              if(value!.length < 11 || value.length > 11){
                return 'Mobile number must be 11 letters';
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            decoration: InputDecoration(
                hintText: 'Password'
            ),
            validator: (String? value){
              if(value?.isEmpty == true){
                return 'Enter a valid password';
              }
              if(value!.length < 6){
                return 'password must be 6 or more characters';
              }
              return null;
            },
          ),
          SizedBox(height: 32,),
          Visibility(
            visible: !_inProgress,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
                onPressed: _onTabNextButton, child:
            Icon(Icons.arrow_circle_right_outlined)),
          ),
        ],
      ),
    );
  }

  void _onTabNextButton(){
    if(_formKey.currentState!.validate()){
      _singUp();
    }
  }

  Future<void> _singUp() async{
    _inProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registerUrl,
        body: requestBody,
    );
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
      _clearTextField();
      showSnackBar(context, 'Registration Successful!',false);
    }else{
       showSnackBar(context, response.errorMessage,true);
    }
  }

  void _clearTextField(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
