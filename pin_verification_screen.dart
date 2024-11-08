import 'package:assingments/Data/Urls/urls.dart';
import 'package:assingments/Screen/setNew_password_screen.dart';
import 'package:assingments/Screen/sing_in_screen.dart';
import 'package:assingments/Utils/app_color.dart';
import 'package:assingments/Widgets/background_screen.dart';
import 'package:assingments/Widgets/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Data/Models/network_response.dart';
import '../Data/Service/network_caller.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {

  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool inProgress = false;

  get email => null;

  get otp => null;

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
                      Text('Pin Verification',style:
                      textTheme.headlineMedium?.copyWith(fontWeight:
                      FontWeight.bold),),
                      SizedBox(height: 12,),
                      Text('A 6 digit verification code has been sent your email',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24,),

                      buildPinVerificationForm(),

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

  Widget buildPinVerificationForm() {
    return Column(
      children: [
        buildPinCodeTextField(),
        SizedBox(height: 38,),
        ElevatedButton(
            onPressed: _onTabNextBtnScreen, child:
        Icon(Icons.arrow_circle_right_outlined)),
      ],
    );
  }

  void _onTabNextBtnScreen(){
    if (_formKey.currentState!.validate()) {
      _recoverVerifyOtp();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SetNewPasswordScreen( email:email, otp: otp,)));
    }
  }

  Widget buildPinCodeTextField() {
    return Form(
      key: _formKey,
      child: PinCodeTextField(
          controller: _pinTEController,
          keyboardType: TextInputType.number,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            inactiveColor: Colors.greenAccent,
            errorBorderColor: Colors.red,
            activeColor: Colors.green,
            activeFillColor: Colors.cyanAccent,
          ),
          animationDuration: Duration(milliseconds: 300),
          enableActiveFill: false,
          onCompleted: (v) {
            print("Completed");
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            return true;
          }, appContext: context,
        ),
    );
  }

  Future<void> _recoverVerifyOtp() async {
    setState(() => inProgress = true);

    final email = widget.email;
    final otp = _pinTEController.text;
    final url = '${Urls.verifyOtp}$email/$otp';

    final NetworkResponse response = await NetworkCaller.getRequest(url: url);
    setState(() => inProgress = false);

    if (response.isSuccess) {
      showSnackBar(context, 'Verification Successful!');
      _pinTEController.clear();
    } else {
      showSnackBar(context, response.errorMessage);
    }
  }

}

