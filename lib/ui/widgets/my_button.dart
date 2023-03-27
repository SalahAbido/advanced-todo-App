import 'package:flutter/material.dart';

import '../../modules/themes.dart';

class buildGestureDetector extends StatelessWidget {
  final String label;
  final Function () ontap;

  const buildGestureDetector({
    super.key,
    required this.label,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap:() =>  ontap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
        alignment: Alignment.center,
        // width: size.width * 0.25,
        // height: size.height * 0.05,
        decoration: BoxDecoration(
            color: primaryClr, borderRadius: BorderRadius.circular(20.0)),
        child:  Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}