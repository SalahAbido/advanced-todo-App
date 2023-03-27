import 'package:advanced_todo_app/controllers/task_controller.dart';
import 'package:advanced_todo_app/modules/task.dart';
import 'package:advanced_todo_app/modules/themes.dart';
import 'package:advanced_todo_app/ui/screens/notification_screen.dart';
import 'package:advanced_todo_app/ui/widgets/tasktile.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';
import '../screens/task_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../services/theme_servces.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime selectedTime = DateTime.now();
  late NotificationController noti;

  @override
  void initState() {
    super.initState();
    noti = NotificationController();
    noti.initializeNoification();
    // _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var orian = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTaskBar(),
            SizedBox(
              height: orian == Orientation.landscape ? 10.0 : 0.0,
            ),
            CalendarTimeline(
              initialDate: selectedTime,
              firstDate: DateTime(2019, 1, 15),
              lastDate: DateTime(2024, 11, 20),
              showYears: orian == Orientation.landscape ? false : true,
              onDateSelected: (date) => setState(() => selectedTime = date),
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Get.isDarkMode ? Colors.white : Colors.black,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: primaryClr,
              dotsColor: const Color(0xFFFFFFFF),
              // selectableDayPredicate: (date) => date.day != 24,
              locale: 'en',
            ),
            Expanded(
              child: Obx(
                () {
                  if (_taskController.Tasks.isEmpty) {
                    return buildNotApearingTasks(orian);
                  } else {
                    return RefreshIndicator(
                      onRefresh: fresh,
                      child: ListView.builder(
                        scrollDirection: orian == Orientation.landscape
                            ? Axis.horizontal
                            : Axis.vertical,
                        itemCount: _taskController.Tasks.length,
                        itemBuilder: (context, index) {
                          Task task = _taskController.Tasks[index]; ///////////
                          if ((task.repeat == 'Daily' ||
                                  DateFormat.yMd().format(selectedTime) ==
                                      task.date) ||
                              (task.repeat == 'Weekly' &&
                                  (selectedTime
                                              .difference(DateFormat.yM()
                                                  .parse(task.date!))
                                              .inDays %
                                          7) ==
                                      0) ||
                              (task.repeat == 'Monthly' &&
                                  selectedTime.day ==
                                      DateFormat.yMd().parse(task.date!).day)) {
                            var hour = task.startTime!.split(':')[0];
                            var minutes = task.startTime!.split(':')[1];
                            // debugPrint('$hour#####');
                            // print('$minutes#####');
                            var date = DateFormat.jm().parse(task.startTime!);
                            var myTime = DateFormat('HH:mm').format(date);
                            print(
                                '${int.parse(myTime.toString().split(':')[0])}#####');
                            print(
                                '${int.parse(myTime.toString().split(':')[1])}#####');
                            noti.scheduledNotification(
                              int.parse(myTime.toString().split(':')[0]),
                              int.parse(myTime.toString().split(':')[1]),
                              task,
                            );
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: orian == Orientation.landscape
                                    ? 50.0
                                    : null,
                                horizontalOffset: orian == Orientation.landscape
                                    ? null
                                    : 300.0,
                                child: FadeInAnimation(
                                  child: TaskTile(
                                    task,
                                    onpress: () => showBottomShe(size, task),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBottomShe(size, Task task) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        // borderRadius: BorderRadius.circular(25.0)
      ),
      height: task.isCompleted == 0 ? size.height * 0.4 : size.height * 0.3,
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            const SizedBox(height: 10.0),
            task.isCompleted == 0
                ? bottomSheetItem(
                    size,
                    ontap: () {
                      noti.cancelNotification(task);
                      _taskController.updateTask(task.id!);
                      Get.back();
                    },
                    label: 'Task Completed',
                    clr: primaryClr,
                  )
                : Container(),
            bottomSheetItem(
              size,
              ontap: () {
                noti.cancelNotification(task);
                _taskController.deleteTask(task);
                Get.back();
              },
              label: 'Delete Task',
              clr: pinkClr,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            bottomSheetItem(
              size,
              ontap: () {
                Get.back();
              },
              label: 'cancel',
              clr: primaryClr,
            ),
          ],
        ),
      ),
    ));
  }

  GestureDetector bottomSheetItem(Size size,
      {required String label,
      required Function() ontap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        alignment: Alignment.center,
        height: 65.0,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          label,
          style: subheadingStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Stack buildNotApearingTasks(Orientation orian) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: fresh,
            child: SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                direction: orian == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizedBox(
                    height: orian == Orientation.landscape ? 6.0 : 220.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/task.svg',
                    height: 120.0,
                    color: primaryClr.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "You don't have any tasks yet \n Add new Tasks to make Your day Productive",
                    style: subheadingStyle.copyWith(fontSize: 15.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: orian == Orientation.landscape ? 6.0 : 120.0,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Flutter Demo',
        style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode ? Icons.sunny : Icons.nightlight_round_sharp,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () async {
          ThemeServices().ChangeTheme();
          await noti.displayNotification(
              title: 'Done', body: 'your Theme is Successfully changed');
          // noti.scheduleNotification();
        },
      ),
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.cleaning_services_outlined,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () async {
            await noti.cancelAllNotification();
            await _taskController.deleteAll();
          },
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 20.0,
          ),
        )
      ],
    );
  }

  Row buildTaskBar() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subheadingStyle,
            ),
            Text(
              'To Day',
              style: headingStyle,
            ),
          ],
        ),
        const Spacer(),
        buildGestureDetector(
          label: '+Add task',
          ontap: () async {
            await Get.to(() =>
                const AddTaskScreen()); //width is equal 360.0 height is equal 680.0
            _taskController.getTasks();
          },
        )
      ],
    );
  }

  Future<void> fresh() async {
    await _taskController.getTasks();
    print(_taskController.Tasks.length);
  }
}
