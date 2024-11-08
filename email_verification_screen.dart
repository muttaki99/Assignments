import 'dart:html';

import 'package:assingments/Data/Models/network_response.dart';
import 'package:assingments/Data/Service/network_caller.dart';
import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Screen/pin_verification_screen.dart';
import 'package:assingments/Screen/sing_in_screen.dart';
import 'package:assingments/Utils/app_color.dart';
import 'package:assingments/Widgets/background_screen.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  final TextEditingController _verifyEmailController = TextEditingController();
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  bool inProgress = false;

  get email => null;

  @override
  Widget build(BuildContext context) {

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundScreen(child:
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                        SizedBox(height: 82,),
                        Text('Email Verification',style:
                        textTheme.headlineMedium?.copyWith(fontWeight:
                        FontWeight.bold),),
                        SizedBox(height: 12,),
                        Text('A 6 digit verification code will be sent your email',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24,),

                        buildEmailVerificationForm(),

                        SizedBox(height: 48,),

                 Center(
                  child: Column(
                    children: [
                      buildSingInSection(),
                    ]
                  )
                ),
              ],
            ),
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
                recognizer: TapGestureRecognizer()..onTap = _onTabSingUpScreen
              )
            ]
        )
    );
  }

  void _onTabSingUpScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SingInScreen()));
  }

  Widget buildEmailVerificationForm() {
    return Column(
      children: [
        TextFormField(
          controller: _verifyEmailController,
          decoration: InputDecoration(
              hintText: 'Email'
          ),
          validator: (String? value){
            if(value?.isEmpty ?? true){
              return 'please enter a email for the verification';
            }
            return null;
          },
        ),
        SizedBox(height: 38,),
        Visibility(
          visible: !inProgress,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: ElevatedButton(
              onPressed: _onTabNextScreen, child:
          Icon(Icons.arrow_circle_right_outlined)),
        ),
      ],
    );
  }

  void _onTabNextScreen(){
    if(!_formKey.currentState!.validate()){
      _emailVerification();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PinVerificationScreen(email: email,)));
    }

  }

  Future<void> _emailVerification()async{
    inProgress = true;
    setState(() {});

    String email = _verifyEmailController.text.trim();
    final url = '${Urls.verifyEmail}$email';

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: url);
    inProgress = false;
    setState(() {});
    if(response.isSuccess){
      showSnackBar(context, 'OTP has sent to your email!');
    }else{
      showSnackBar(context, response.errorMessage);
    }
  }

}
