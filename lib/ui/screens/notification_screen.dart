import 'package:advanced_todo_app/services/theme_servces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/themes.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String _paylad;

  @override
  void initState() {
    _paylad = widget.payload;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.primaryColor,
        elevation: 5,
        title: Text(_paylad.split('|')[0]),
        leading: IconButton(
          onPressed: () {
            Get.back();
            ThemeServices().ChangeTheme();
          },
          icon:  Icon(Icons.arrow_back_ios_new_rounded,color: Get.isDarkMode?Colors.white: darkGreyClr,),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                 Text(
                  'Hello,Salah',
                  style: TextStyle(
                    color:Get.isDarkMode?Colors.white: darkGreyClr,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  'you,have new remember',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: bluishClr.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.text_increase_outlined,
                                color: Colors.white, size: 35.0),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              'Title',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            )
                          ],
                        ),
                      ),
                      Text(
                        _paylad.split('|')[0],
                        style: textStyle1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.description,
                                color: Colors.white, size: 35.0),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            )
                          ],
                        ),
                      ),
                      Text(
                        _paylad.split('|')[1],
                        style: textStyle1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.date_range_outlined,
                                color: Colors.white, size: 35.0),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              'Date',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            )
                          ],
                        ),
                      ),
                      Text(
                        _paylad.split('|')[2],
                        textAlign: TextAlign.justify,
                        style: textStyle1.copyWith(fontSize: 20.0),
                        // textDirection: TextDecoration.,
                        // softWrap: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
