import 'package:advanced_todo_app/modules/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../modules/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function() onpress;

  const TaskTile(
    this.task, {
    super.key,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var orian = MediaQuery.of(context).orientation;
    return GestureDetector(
      onTap: onpress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: orian== Orientation.landscape?8.0:0),
        padding:EdgeInsets.symmetric(vertical: orian== Orientation.landscape?0:size.width * 0.07, horizontal: 15.0),
        width: orian == Orientation.landscape ? size.width / 2 : size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: getColor(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: subheadingStyle.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 18, color: Colors.white),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        '${task.startTime} - ${task.endTime}',
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    task.note!,
                    style: bodytextStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 60.0,
              width: 1,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'TODO' : 'Completed',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getColor(int? color) {
    switch (color) {
      case 0:
        return primaryClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return primaryClr;
    }
  }
}
