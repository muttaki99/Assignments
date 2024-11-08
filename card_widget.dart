import 'package:flutter/material.dart';

class TaskSummeryCard extends StatelessWidget {
  const TaskSummeryCard({
    super.key, required this.count, required this.title,
  });

  final int count;
  final String title;


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child:
      SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${count}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}