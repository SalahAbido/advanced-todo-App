import 'package:advanced_todo_app/modules/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextFormField extends StatelessWidget {
  final String title;
  final String hint;
  final Widget? child;

  final TextEditingController? controller;

  const MyTextFormField({
    super.key,
    required this.title,
    required this.hint,
    this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( vertical: 8.0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            alignment: Alignment.center,
            // padding: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
                color: context.theme.backgroundColor,
                borderRadius: BorderRadius.circular(15.0)),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: hint,
                  // label: Text(title,
                  //     style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  hintStyle: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  helperStyle: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  suffixIcon: child,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.solid,
                        color: Colors.red,
                      )),
                  labelStyle: subtileStyle),
            ),
          ),
        ],
      ),
    );
  }
}
