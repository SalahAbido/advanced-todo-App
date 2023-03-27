import 'package:advanced_todo_app/controllers/notification_controller.dart';
import 'package:advanced_todo_app/controllers/task_controller.dart';
import 'package:advanced_todo_app/modules/themes.dart';
import 'package:advanced_todo_app/ui/screens/home_page.dart';
import 'package:advanced_todo_app/ui/widgets/my_button.dart';
import 'package:advanced_todo_app/ui/widgets/my_text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../db/db_helper.dart';
import '../../modules/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();
  int? _selectedremaind = 5;
  final List<int> _remanindList = [5, 10, 15, 20];
  String? _selectedRepeat = 'None';
  final List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  final List<Color> _colorList = [bluishClr, pinkClr, orangeClr];
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyTextFormField(
                title: 'title',
                hint: 'Enter Title Here',
                controller: _titleController,
              ),
              MyTextFormField(
                title: 'Note',
                hint: 'Enter Note Here',
                controller: _noteController,
              ),
              MyTextFormField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                child: IconButton(
                    onPressed: () => getDate(),
                    icon: const Icon(Icons.date_range_outlined)),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextFormField(
                      title: 'Start Time',
                      hint: _startTime,
                      child: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          await getTime(isStart: true);
                          print(_startTime);
                          print('${_startTime.split(':')[0]}#############');
                          print('${_startTime.split(':')[1]}#############');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: MyTextFormField(
                      title: 'End Time',
                      hint: _endTime,
                      child: IconButton(
                          onPressed: () => getTime(isStart: false),
                          icon: const Icon(Icons.access_time_rounded)),
                    ),
                  ),
                ],
              ),
              MyTextFormField(
                title: 'Remind',
                hint: '$_selectedremaind minutes',
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownButton<int>(
                    value: _selectedremaind,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: subtileStyle,
                    underline: Container(),
                    items: _remanindList
                        .map<DropdownMenuItem<int>>(
                          (value) =>
                          DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          ),
                    )
                        .toList(),
                    //List<DropdownMenuItem<int>>?
                    onChanged: (val) {
                      setState(() {
                        _selectedremaind = val;
                      });
                    },
                  ),
                ),
              ),
              MyTextFormField(
                title: 'Repeat',
                hint: _selectedRepeat.toString(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.0),
                    underline: const Divider(
                      endIndent: 25.0,
                      color: Colors.black,
                      height: 0.0,
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: subtileStyle,
                    value: _selectedRepeat,
                    items: _repeatList
                        .map<DropdownMenuItem<String>>(
                          (value) =>
                          DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString()),
                          ),
                    )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedRepeat = val;
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildColorPaltte(),
                  buildGestureDetector(
                    label: 'create task',
                    ontap: () {
                      Task task = Task(
                        title: _titleController.text,
                        note: _noteController.text,
                        color: selectedColor,
                        startTime: _startTime,
                        endTime: _endTime,
                        date: DateFormat.yMd().format(_selectedDate),
                        isCompleted: 0,
                        remaind: _selectedremaind,
                        repeat: _selectedRepeat,
                      );
                      validateData(task);
                      /*NotificationController().scheduledNotification(
                          int.parse(_startTime.split(':')[0]),
                          int.parse(_startTime.split(':')[1]),
                          task);*/
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  validateData(Task task) {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      addTaskToDb(task);
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('error', ' You have to enter title and note ',
          borderRadius: 15.0,
          colorText: Colors.pink,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.pink,
          ),
          snackPosition: SnackPosition.TOP);
    } else {
      print('there are large error');
    }
  }

  addTaskToDb(Task task) async {
    int value = await _taskController.addTask(task,);
    print(value);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Flutter Demo'),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 20.0,
          ),
        )
      ],
    );
  }

  Column buildColorPaltte() {
    return Column(
      children: [
        Text(
          'Color',
          style: subtileStyle,
        ),
        Row(
          children: _colorList
              .map((val) =>
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = _colorList.indexOf(val);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: val,
                    radius: 16.0,
                    child: selectedColor == _colorList.indexOf(val)
                        ? Icon(Icons.done)
                        : null,
                  ),
                ),
              ))
              .toList(),
        )
      ],
    );
  }

  getDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    setState(() {
      _selectedDate = newDate;
    });
  }

  getTime({required bool isStart}) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: isStart
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );
    if (newTime == null) return;
    isStart
        ? setState(() {
      _startTime = newTime.format(context);
    })
        : setState(() {
      _endTime = newTime.format(context);
    });
  }
}
