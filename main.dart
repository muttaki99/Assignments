import 'package:assingments/Data/Controller/auth_controller.dart';
import 'package:assingments/Screen/main_btm_navbar.dart';
import 'package:assingments/Screen/sing_in_screen.dart';
import 'package:assingments/Utils/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Utils/app_color.dart';
import 'Widgets/background_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),
      debugShowCheckedModeBanner: false,
      home: MyBagScreen(),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData(){
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          fixedSize: Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
    );
}

  OutlineInputBorder _inputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,

    );
  }
}

class MyBagScreen extends StatefulWidget {
   const MyBagScreen({super.key});

  @override
  _MyBagScreenState createState() => _MyBagScreenState();
}

class _MyBagScreenState extends State<MyBagScreen> {

  @override
  void initState(){
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen()async{
    await Future.delayed(Duration(seconds: 3));
    await AuthController.getAccessToken();
    if(AuthController.isLoggedIn()) {
      await AuthController.getUserData();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MainBottomNavbar()));
    } else{
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => SingInScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
        child: Center(
            child: SvgPicture.asset(AssetsPath.logoSvg)),
      )

    );
  }
}



