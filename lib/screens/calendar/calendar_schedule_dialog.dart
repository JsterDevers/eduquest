import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calendar_models.dart';

class CalendarScheduleDialog extends StatefulWidget {
  const CalendarScheduleDialog({
    super.key,
    required this.initialDate,
    this.initialDeadline,
  });

  final DateTime initialDate;
  final Deadline? initialDeadline;

  static Future<Deadline?> show(
    BuildContext context, {
    required DateTime initialDate,
    Deadline? initialDeadline,
  }) {
    return showDialog<Deadline>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CalendarScheduleDialog(
          initialDate: initialDate,
          initialDeadline: initialDeadline,
        ),
      ),
    );
  }

  @override
  State<CalendarScheduleDialog> createState() => _CalendarScheduleDialogState();
}

class _CalendarScheduleDialogState extends State<CalendarScheduleDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final List<String> _subjectOptions = [
    'Filipinolohiya',
    'Accounting',
    'Pagsasalin',
    'Polgov',
  ];
  final List<String> _studyHubOptions = ['Flashcard', 'Practice Test'];
  final List<String> _studyMethodOptions = [
    'Spaced Repetition',
    'Active Recall',
    'Pomodoro Timer',
  ];
  String? _selectedSubject;
  String? _selectedStudyHub;
  String? _selectedStudyMethod;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = TimeOfDay.now();
    _selectedSubject = _subjectOptions.first;
    _selectedStudyHub = _studyHubOptions.first;
    _selectedStudyMethod = _studyMethodOptions.first;

    if (widget.initialDeadline != null) {
      final deadline = widget.initialDeadline!;

      if (!_subjectOptions.contains(deadline.title)) {
        _subjectOptions.add(deadline.title);
      }
      if (deadline.studyHub.isNotEmpty &&
          !_studyHubOptions.contains(deadline.studyHub)) {
        _studyHubOptions.add(deadline.studyHub);
      }
      if (deadline.studyMethod.isNotEmpty &&
          !_studyMethodOptions.contains(deadline.studyMethod)) {
        _studyMethodOptions.add(deadline.studyMethod);
      }

      _selectedSubject = deadline.title;
      _selectedStudyHub = deadline.studyHub.isNotEmpty
          ? deadline.studyHub
          : _studyHubOptions.first;
      _selectedStudyMethod = deadline.studyMethod.isNotEmpty
          ? deadline.studyMethod
          : _studyMethodOptions.first;

      final parsedDate = _parseDeadlineDate(deadline.date);
      if (parsedDate != null) {
        _selectedDate = parsedDate;
      }
      final parsedTime = _parseDeadlineTime(deadline.date);
      if (parsedTime != null) {
        _selectedTime = parsedTime;
      }
    }
  }

  DateTime? _parseDeadlineDate(String dateString) {
    final dateRegex = RegExp(r'([A-Za-z]+)\s+(\d{1,2})(?:,\s*(\d{4}))?');
    final match = dateRegex.firstMatch(dateString);
    if (match == null) {
      return null;
    }

    final monthName = match.group(1)?.toUpperCase();
    final day = int.tryParse(match.group(2) ?? '');
    final year = int.tryParse(match.group(3) ?? '');
    if (monthName == null || day == null) {
      return null;
    }

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
    final monthIndex = monthNames.indexOf(monthName);
    if (monthIndex < 0) {
      return null;
    }

    return DateTime(year ?? DateTime.now().year, monthIndex + 1, day);
  }

  TimeOfDay? _parseDeadlineTime(String dateString) {
    final timeRegex = RegExp(r'(\d{1,2}:\d{2}\s*[AP]M)', caseSensitive: false);
    final match = timeRegex.firstMatch(dateString);
    if (match == null) {
      return null;
    }

    final timeText = match.group(1);
    if (timeText == null) {
      return null;
    }

    final parsed = RegExp(
      r'(\d{1,2}):(\d{2})\s*([AP]M)',
      caseSensitive: false,
    ).firstMatch(timeText);
    if (parsed == null) {
      return null;
    }

    var hour = int.tryParse(parsed.group(1) ?? '0') ?? 0;
    final minute = int.tryParse(parsed.group(2) ?? '0') ?? 0;
    final period = parsed.group(3)?.toUpperCase();
    if (period == 'PM' && hour < 12) {
      hour += 12;
    }
    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatDate(DateTime date) {
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
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF753896),
            onPrimary: Colors.white,
            onSurface: Color(0xFF381B4B),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF753896),
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveSchedule() {
    final subject = _selectedSubject?.trim() ?? '';
    if (subject.isEmpty ||
        _selectedStudyHub == null ||
        _selectedStudyMethod == null) {
      return;
    }

    final schedule = Deadline(
      title: subject,
      date: '${_formatDate(_selectedDate)} · ${_formatTime(_selectedTime)}',
      studyHub: _selectedStudyHub!,
      studyMethod: _selectedStudyMethod!,
      icon: widget.initialDeadline?.icon ?? Icons.schedule,
      notes: widget.initialDeadline?.notes ?? '',
    );

    Navigator.of(context).pop(schedule);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5E2C4),
        border: Border.all(color: const Color(0xFF381B4B), width: 4),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CREATE SCHEDULE',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF381B4B),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF381B4B)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildLabel('Date'),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF381B4B), width: 2),
                foregroundColor: const Color(0xFF381B4B),
              ),
              onPressed: _pickDate,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _formatDate(_selectedDate),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 10,
                    color: Color(0xFF381B4B),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel('Time'),
            const SizedBox(height: 8),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF381B4B), width: 2),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  0,
                  1,
                  1,
                  _selectedTime.hour,
                  _selectedTime.minute,
                ),
                use24hFormat: false,
                onDateTimeChanged: (value) {
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: value.hour,
                      minute: value.minute,
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel('Subject'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedSubject,
              items: _subjectOptions,
              onChanged: (value) => setState(() {
                _selectedSubject = value;
              }),
            ),
            const SizedBox(height: 16),
            _buildLabel('Study Hub'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedStudyHub,
              items: _studyHubOptions,
              onChanged: (value) => setState(() {
                _selectedStudyHub = value;
              }),
            ),
            const SizedBox(height: 16),
            _buildLabel('Study Method'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedStudyMethod,
              items: _studyMethodOptions,
              onChanged: (value) => setState(() {
                _selectedStudyMethod = value;
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF753896),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _saveSchedule,
              child: const Text('SAVE SCHEDULE'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'PressStart2P',
        color: Color(0xFF381B4B),
        fontSize: 9,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF381B4B), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF381B4B)),
        items: items
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(
                  option,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF381B4B),
                    fontSize: 10,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}