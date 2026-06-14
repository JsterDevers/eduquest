import 'package:flutter/material.dart';
import 'calendar_models.dart';

class CalendarController {
  DateTime selectedDate = DateTime(2026, 3, 1);

  final List<Deadline> deadlines = [];

  void addDeadline(Deadline deadline) {
    deadlines.add(deadline);
  }

  void updateDeadline(int index, Deadline deadline) {
    if (index >= 0 && index < deadlines.length) {
      deadlines[index] = deadline;
    }
  }

  void deleteDeadline(int index) {
    if (index >= 0 && index < deadlines.length) {
      deadlines.removeAt(index);
    }
  }

  DateTime? _parseDeadlineDate(String dateString) {
    const monthNames = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];

    final dateRegex = RegExp(r'([A-Za-z]+)\s+(\d{1,2})');
    final match = dateRegex.firstMatch(dateString);
    if (match == null) return null;

    final monthName = match.group(1)?.toUpperCase();
    final day = int.tryParse(match.group(2) ?? '');
    if (monthName == null || day == null) return null;

    final monthIndex = monthNames.indexOf(monthName);
    if (monthIndex < 0) return null;

    return DateTime(DateTime.now().year, monthIndex + 1, day);
  }

  List<Deadline> getSortedDeadlines() {
    final sorted = List<Deadline>.from(deadlines);
    sorted.sort((a, b) {
      final dateA = _parseDeadlineDate(a.date);
      final dateB = _parseDeadlineDate(b.date);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateA.compareTo(dateB);
    });
    return sorted;
  }

  final List<ClassPeriod> classPeriods = [];

  void updateClassPeriods(List<ClassPeriod> periods) {
    classPeriods
      ..clear()
      ..addAll(periods);
  }

  final List<CalendarQuest> quests = const [];

  String get monthName => _monthNames[selectedDate.month - 1];
  int get year => selectedDate.year;

  bool get isCurrentDateMonth {
    final now = DateTime.now();
    return selectedDate.month == now.month && selectedDate.year == now.year;
  }

  static const List<String> _monthNames = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];

  void previousMonth() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
  }

  void nextMonth() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
  }

  int daysInMonth() {
    return DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);
  }

  int firstDayOffset() {
    return DateTime(selectedDate.year, selectedDate.month, 1).weekday % 7;
  }

  List<String> get weekLabels => const ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  List<String> tasksForDay(int day) {
    final quest = quests.firstWhere(
      (entry) => entry.day == day,
      orElse: () => const CalendarQuest(day: 0, tasks: []),
    );
    return quest.tasks;
  }

  bool hasDeadlineOnDay(int day) {
    return deadlines.any((deadline) {
      final deadlineDate = _parseDeadlineDate(deadline.date);
      if (deadlineDate == null) return false;
      return deadlineDate.day == day &&
          deadlineDate.month == selectedDate.month &&
          deadlineDate.year == selectedDate.year;
    });
  }
}