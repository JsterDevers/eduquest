import 'package:flutter/material.dart';

class Deadline {
  final String title;
  final String date;
  final String studyHub;
  final String studyMethod;
  final String notes;
  final IconData icon;

  const Deadline({
    required this.title,
    required this.date,
    required this.icon,
    this.studyHub = '',
    this.studyMethod = '',
    this.notes = '',
  });

  Deadline copyWith({
    String? title,
    String? date,
    String? studyHub,
    String? studyMethod,
    String? notes,
    IconData? icon,
  }) {
    return Deadline(
      title: title ?? this.title,
      date: date ?? this.date,
      studyHub: studyHub ?? this.studyHub,
      studyMethod: studyMethod ?? this.studyMethod,
      notes: notes ?? this.notes,
      icon: icon ?? this.icon,
    );
  }
}

class CalendarQuest {
  final int day;
  final List<String> tasks;

  const CalendarQuest({required this.day, required this.tasks});
}

class ClassPeriod {
  final String day;
  final String subject;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const ClassPeriod({
    required this.day,
    required this.subject,
    required this.startTime,
    required this.endTime,
  });

  ClassPeriod copyWith({
    String? day,
    String? subject,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return ClassPeriod(
      day: day ?? this.day,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}