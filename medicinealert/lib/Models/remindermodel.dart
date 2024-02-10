import 'package:flutter/material.dart';

class ReminderData {
  final String name;
  final String description;
  final String title;
  late final DateTime date;
  final TimeOfDay time;
  final String repeatDaily;

  ReminderData({
    required this.name,
    required this.description,
    required this.title,
    required this.date,
    required this.time,
    required this.repeatDaily,
  });

  factory ReminderData.fromJson(Map<String, dynamic> json) {
    return ReminderData(
      name: json['name'],
      description: json['description'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['hour'],
        minute: json['minute'],
      ),
      repeatDaily: json['repeatDaily'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'title': title,
      'date': date.toIso8601String(),
      'hour': time.hour,
      'minute': time.minute,
      'repeatDaily': repeatDaily,
    };
  }
}
