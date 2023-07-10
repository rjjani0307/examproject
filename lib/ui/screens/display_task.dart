import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_managment/ui/screens/add_task_screen.dart';
import 'package:task_managment/ui/screens/home_screen.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';

class DisplayTask extends StatefulWidget {
  final int id;

  const DisplayTask({Key? key, required this.id}) : super(key: key);

  @override
  _DisplayTaskState createState() => _DisplayTaskState();
}

class _DisplayTaskState extends State<DisplayTask> {
  List colors = [
    0xff648e9a,
    0xFFFF80A6,
    0xFF3699EC,
    0xff648e9a,
    0xFFFFC04E,
    0xff8c0335,
    0xff103b40,
    0xff191A19
  ];
  Task? task;
  TaskController _taskController = TaskController();

  @override
  void initState() {
    print("welcome  " + widget.id.toString());
    getTask();
    super.initState();
  }

  Future getTask() async {
    task = await _taskController.getTask(widget.id);
    setState(() {});
    print('this one: ${task!.toJson()}');
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(colors[int.parse(task!.color.toString())]),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(colors[int.parse(task!.color.toString())]),
          actions: [editButton()],
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:
                  Icon(Icons.arrow_back_ios, size: 20.0, color: Colors.white)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "${task!.date}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "${task!.startTime}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: 1.5,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 18,
                  ),
                  Text(
                    "${task!.repeat}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: 1.5,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.access_alarms_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  Text(
                    "${task!.remind} Minutes Early",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '${task!.title}',
                style: GoogleFonts.bitter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                '${task!.note}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        Get.to(() => AddTaskPage(
              id: widget.id,
            ));
      });

}
