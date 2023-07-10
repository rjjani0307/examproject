import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_managment/db/db_helper.dart';
import 'package:task_managment/ui/screens/home_screen.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../theme.dart';
import '../widgets/buttonWidget.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key, this.id}) : super(key: key);

  int? id;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  void initState() {
    // TODO: implement initState
    widget.id != null ? getTask() : super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      widget.id == null ? _addTaskToDB() : _updateTask();
      _taskController.getTasks();
    }
  }
  _updateTask() async{
   Task task =  Task(
        id: widget.id,
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0
    );
   print(task.toJson());
    int? value = await _taskController.updateTask(
        task:task );
    print("updateTask: "+value.toString()+"widgetid "+ widget.id.toString()
    );
  }

  _uploadTask() async {
    int value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      date:DateFormat('yyyy-MM-dd').format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print(value);
  }


  getTask() async {
    task = await _taskController.getTask(widget.id!.toInt());
    setState(() {
      _selectedColor = task!.color!.toInt();
      _titleController.text = task!.title.toString();
      _noteController.text = task!.note.toString();
      _selectedDate = DateFormat('yyyy-MM-dd').parse(task!.date!);
      _startTime = task!.startTime.toString();
      _endTime = task!.endTime.toString();
      _selectedRepeat = task!.repeat.toString();
    });
    print("load  " + task.toString());
  }

  Task? task;

  final TaskController _taskController = Get.find<TaskController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  String _startTime = "8:30 AM";
  String _endTime = "9:30 AM";
  int _selectedColor = 0;

  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', ];

  @override
  Widget build(BuildContext context) {
    print("add Task date: " + DateFormat.yMd().format(_selectedDate));
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                InputField(
                  title: "Title",
                  hint: "Enter title here.",
                  controller: _titleController,
                ),
                InputField(
                    title: "Note",
                    hint: "Enter note here.",
                    controller: _noteController),
                InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () {
                      //_showDatePicker(context);
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          icon: Icon(Icons.lock_clock),
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: InputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          icon: Icon(Icons.lock_clock),
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                        ),
                      ),
                    )
                  ],
                ),
                // InputField(
                //   title: "Remind",
                //   hint: "$_selectedRemind minutes early",
                //   widget: Row(
                //     children: [
                //       DropdownButton<String>(
                //           //value: _selectedRemind.toString(),
                //           icon: Icon(
                //             Icons.keyboard_arrow_down,
                //             color: Colors.grey,
                //           ),
                //           iconSize: 32,
                //           elevation: 4,
                //           style: subTitleStyle,
                //           underline: Container(height: 0),
                //           onChanged: (String? newValue) {
                //             setState(() {
                //               _selectedRemind = int.parse(newValue!);
                //             });
                //           },
                //           items: remindList
                //               .map<DropdownMenuItem<String>>((int value) {
                //             return DropdownMenuItem<String>(
                //               value: value.toString(),
                //               child: Text(value.toString()),
                //             );
                //           }).toList()),
                //       SizedBox(width: 6),
                //     ],
                //   ),
                // ),
                InputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton<String>(
                          //value: _selectedRemind.toString(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRepeat = newValue!;
                            });
                          },
                          items: repeatList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                _colorChips(),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: MyButton(
                    height: 50,
                    width: 300,
                    label: widget.id == null ? 'Create Task' : 'Update Task',
                    onTap: () {
                      _validateInputs();
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _submit();
      Get.to(HomePage());
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("############ SOMETHING BAD HAPPENED #################");
    }
  }

  _addTaskToDB() async {
    print('id sojitra ${widget.id}');
    await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print('id sojitra ${widget.id}');
  }

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        "Color",
        style: titleStyle,
      ),
      SizedBox(
        height: 8,
      ),
      Center(
        child: Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: index == _selectedColor
                        ? Center(
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    ]);
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      title: Text(
        "Add Task",
        style: headingStyle,
      ),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
      ),
    );
  }

  // _compareTime() {
  //   print("compare time");
  //   print(_startTime);
  //   print(_endTime);

  //   var _start = double.parsestartTime);
  //   var _end = toDouble(_endTime);

  //   print(_start);
  //   print(_end);

  //   if (_start > _end) {
  //     Get.snackbar(
  //       "Invalid!",
  //       "Time duration must be positive.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       overlayColor: context.theme.backgroundColor,
  //     );
  //   }
  // }

  // double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    print(_pickedTime.format(context));
    String _formatedTime = _pickedTime.format(context);
    print(_formatedTime);
    if (_pickedTime == null)
      print("time canceld");
    else if (isStartTime)
      setState(() {
        _startTime = _formatedTime;
      });
    else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
      //_compareTime();
    }
  }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay(hour: 8, minute: 30),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
}
