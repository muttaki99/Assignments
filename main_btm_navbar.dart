import 'package:assingments/Screen/cancelled_task_screen.dart';
import 'package:assingments/Screen/completed_task_screen.dart';
import 'package:assingments/Screen/new_task_screen.dart';
import 'package:assingments/Screen/profile_manage_screen.dart';
import 'package:assingments/Screen/progress_task_screen.dart';
import 'package:flutter/material.dart';

import '../Widgets/tm_appbar.dart';

class MainBottomNavbar extends StatefulWidget {
  const MainBottomNavbar({super.key});

  @override
  State<MainBottomNavbar> createState() => _MainBottomNavbarState();
}

class _MainBottomNavbarState extends State<MainBottomNavbar> {

  int _selectedIndex = 0;
  final List<Widget>_screens = [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen(),
    ProfileManageScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index){
          _selectedIndex = index;
          setState(() {
          });
        },
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.task_alt_outlined),
              label: 'New'),
          NavigationDestination(
              icon: Icon(Icons.checklist_outlined),
              label: 'Completed'),
          NavigationDestination(
              icon: Icon(Icons.cancel_presentation_outlined),
              label: 'Cancelled'),
          NavigationDestination(
              icon: Icon(Icons.access_time_outlined),
              label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Profile'),
        ],),
    );
  }
}
