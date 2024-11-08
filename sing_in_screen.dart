import 'package:assingments/Data/Controller/auth_controller.dart';
import 'package:assingments/Data/Models/login_model.dart';
import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Screen/email_verification_screen.dart';
import 'package:assingments/Screen/main_btm_navbar.dart';
import 'package:assingments/Screen/sing_up_screen.dart';
import 'package:assingments/Utils/app_color.dart';
import 'package:assingments/Widgets/background_screen.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
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
                      SizedBox(height: 82,),
                      Text('Get Started With',style:
                      textTheme.headlineMedium?.copyWith(fontWeight:
                      FontWeight.bold),),
                      SizedBox(height: 24,),
                      buildSingInForm(),
                      SizedBox(height: 48,),
               Center(
                child: Column(
                  children: [
                    TextButton(onPressed: _onTabForgotPassBtn, child: Text('Forgot Password?')),
                    buildSingUpSection(),
                  ]
                )
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _onTabForgotPassBtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerificationScreen()));
  }

  Widget buildSingUpSection() {
    return RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            text: "Don't have an account?  ",
            children: [
              TextSpan(
                text: 'Sing Up',style: TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap = _onTabSingUpScreen
              )
            ]
        )
    );
  }

  void _onTabSingUpScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SingUpScreen()));
  }

  Widget buildSingInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _emailTEController,
            decoration: InputDecoration(
                hintText: 'Email'
            ),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'invalid email!';
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Password'
            ),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'invalid password!';
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
    );
  }

  void _onTabNextBtnScreen(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _singIn();
  }

  Future<void> _singIn() async {
    _inProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,body: requestBody
    );
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.data!);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => MainBottomNavbar()), (route) => false);
    }else{
      showSnackBar(context, response.errorMessage);
    }
  }
}
