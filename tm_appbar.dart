import 'package:assingments/Data/Controller/auth_controller.dart';
import 'package:assingments/Screen/profile_screen.dart';
import 'package:flutter/material.dart';

import '../Utils/app_color.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        if(isProfileScreenOpen){
         return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder:
                (context) => ProfileScreen()));
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(AuthController.userData?.photo ?? ''),
              radius: 20,
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AuthController.userData?.fullName ?? '',style:
                TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                    color: Colors.white
                ),),
                Text(AuthController.userData?.email ?? '',style: TextStyle(fontSize: 14,
                    color: Colors.white
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}