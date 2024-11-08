import 'package:assingments/Screen/sing_in_screen.dart';
import 'package:assingments/Utils/app_color.dart';
import 'package:assingments/Widgets/background_screen.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Data/Models/network_response.dart';
import '../Data/Service/network_caller.dart';
import '../Data/Urls/urls.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;


  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: BackgroundScreen(child:
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                      SizedBox(height: 82,),
                      Text('Set New Password',style:
                      textTheme.headlineMedium?.copyWith(fontWeight:
                      FontWeight.bold),),
                      SizedBox(height: 12,),
                      Text('Minimum number of password should be 8 characters.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24,),

                      buildSetPasswordForm(),

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
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) =>
            SingInScreen()), (_) => false);
  }

  Widget buildSetPasswordForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passwordTEController,
            decoration: InputDecoration(
                hintText: 'New Password'
            ),
            validator: (value) {
              final passwordRegex =
              RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@#$%^&+=!]{6,}$');
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (!passwordRegex.hasMatch(value)) {
                return 'At least 6 characters with letters and numbers.';
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            controller: _confirmPasswordTEController,
            decoration: InputDecoration(
                hintText: 'Confirm Password'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              } else if (value != _passwordTEController.text.trim()) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 38,),
          Visibility(
            visible: !inProgress,
            replacement: Center(
              child: CircularProgressIndicator(
              ),
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
    if (_globalKey.currentState!.validate()) {
      _confirmPassword(context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) =>
              SingInScreen()), (_) => false);
    }
  }

  Future<void> _confirmPassword(BuildContext context) async {
    setState(() => inProgress = true);

    final url = Urls.setNewPass;
    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _passwordTEController.text.trim()
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(url: url, body: requestBody);

    setState(() => inProgress = false);

    if (response.isSuccess) {
      showSnackBar(context, 'You have successfully set your new password!');
      _passwordTEController.clear();
      _confirmPasswordTEController.clear();
    } else {
      showSnackBar(context, response.errorMessage);
    }
  }

}
