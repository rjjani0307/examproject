import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/task.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'Task',
          style: TextStyle(
            color: Colors.blue.shade200,
            fontSize: 18,
          ),
        ),
        Text(
          ' Management',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
