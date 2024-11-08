import 'package:assingments/Data/Controller/auth_controller.dart';
import 'package:assingments/Screen/sing_in_screen.dart';
import 'package:flutter/material.dart';

class ProfileManageScreen extends StatelessWidget {
  const ProfileManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 38),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.greenAccent[200],
              child: CircleAvatar(
                radius: 47,
                backgroundImage: AssetImage('lib/Images/muttaki.jpg'), // Update path to your image
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ataullah Muttaki',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '01234567891',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              'muttaki@gmail.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 55),
            Expanded(
              child: ListView(
                children: [
                  ProfileMenuItem(
                    icon: Icons.history,
                    text: 'Task History',
                  ),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip,
                    text: 'Privacy Policy',
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings,
                    text: 'Settings',
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Log out',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;

  ProfileMenuItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[100],
        child: Icon(
          icon,
          color: Colors.green,
        ),
      ),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
      onTap: () async{
        await AuthController.clearUserData();
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) =>
            SingInScreen()), (predicate) => false);
      },
    );
  }
}
