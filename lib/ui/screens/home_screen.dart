import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../res/custom_colors.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../auth_screen/sign_in_screen.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/buttonWidget.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import 'display_task.dart';

class HomePage extends StatefulWidget {
   HomePage({Key? key,})
      :
        super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   // User? user;
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  final GlobalKey<RefreshIndicatorState> _appointmentViewRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Task? taskDetail;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black : darkGreyClr,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.black : darkGreyClr),
                accountName: Text(
                  "",
                  // "${widget.user!.displayName!}",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text(""),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Material(
                      color: CustomColors.firebaseGrey.withOpacity(0.3),
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: CustomColors.firebaseGrey,
                      ),
                    ),
                  ),
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ),
            _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.redAccent,
                    ),
                  )
                : //DrawerHeader
                ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('LogOut'),
                    onTap: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    },
                  ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Task Manager",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.purple.shade200 : darkGreyClr),
            ),
            Text(
              "",
              // " ${widget.user!.displayName!}",
              style: TextStyle(
                  fontSize: 17,
                  color: Get.isDarkMode ? Colors.white : darkGreyClr),
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu_open_outlined,
                  color: Get.isDarkMode
                      ? Colors.white
                      : darkGreyClr // Change Custom Drawer Icon Color
                  ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        /* actions: [
          GestureDetector(
            onTap: () async {
              ThemeServices().switchTheme();
              notifyHelper.displayNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? "Light theme activated."
                    : "Dark theme activated.",
              );
            },
            child: Icon(Get.isDarkMode ? Icons.sunny : Icons.nightlight,
                color: Get.isDarkMode ? Colors.deepOrangeAccent : darkGreyClr),
          ),
          SizedBox(
            width: 20,
          )
        ],*/
      ),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _dateBar(context),
          SizedBox(
            height: 10,
          ),
          Text(
            "${DateFormat("EEE, MMM d").format(_selectedDate)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _dateBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: DatePicker(
        DateTime.now(),
        //height: 100.0,
        initialSelectedDate: DateTime.now(),
        selectionColor: context.theme.backgroundColor,
        selectedTextColor: Colors.blue,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        // deactivatedColor: Colors.white,

        onDateChange: (date) {
          // New date selected

          setState(
            () {
              _selectedDate = date;
              print("date selected ${_selectedDate}  ${_selectedDate.weekday}");
            },
          );
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            height: 50,
            width: 130,
            label: "+ Add Task",
            onTap: () async {
              await Get.to(AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () async {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? "Light theme activated."
                : "Dark theme activated.",
          );

          // var prince  =await  notifyHelper.scheduledNotification();
          //  print( " prince ohk $prince" );
        },
        child: Icon(Get.isDarkMode ? Icons.sunny : Icons.nightlight,
            color: Get.isDarkMode ? Colors.deepOrangeAccent : darkGreyClr),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _taskController.taskList.length,
              itemBuilder: (context, index) {
                Task task = _taskController.taskList[index];
                if (task.repeat == 'Daily') {
                  DateTime date =
                      DateFormat.jm().parse(task.startTime.toString());
                  var myTime = DateFormat("hh:mm").format(date);
                  notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1]),
                      task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onLongPress: () {
                                  showBottomSheet(context, task);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DisplayTask(
                                              id: int.parse(
                                                  task.id.toString()))));
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onLongPress: () {
                                  showBottomSheet(context, task);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DisplayTask(
                                              id: int.parse(
                                                  task.id.toString()))));
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
      }),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1 ? 320 : 320,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  lable: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  Clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              lable: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);

                Get.back();
              },
              Clr: Colors.red.shade300,
              context: context),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              lable: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true,
              Clr: Colors.white,
              context: context),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _bottomSheetButton({
    required String lable,
    required Function()? onTap,
    required Color Clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 55,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.transparent : Clr,
          border: Border.all(
              color: isClose == true ? Colors.black54 : Clr, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          lable,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _noTaskMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            "No Taks for This Day",
            textAlign: TextAlign.center,
            style: subTitleStyle,
          ),
        ),
        SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
