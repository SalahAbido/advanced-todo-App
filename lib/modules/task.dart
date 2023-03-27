import 'dart:convert';

import 'package:advanced_todo_app/modules/themes.dart';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remaind;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remaind,
    this.repeat,
  });
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remaind': remaind,
      'repeat': repeat,
    };
  }
    Task.fromJson(Map<String, dynamic> json ){
       id=json['id'];
      title=json['title'] ;
       note=json['note'];
       isCompleted=json['isCompleted'];
       date=json['date'];
       startTime=json['startTime'];
       endTime=json['endTime'];
       color=json['color'];
       remaind=json['remaind'];
       repeat=json['repeat'];

  }
  // String toJson ()=> json.encode(toMap());
  // factory Task.fromJson(String source)=> Task.fromMap(json.decode(source));

}


