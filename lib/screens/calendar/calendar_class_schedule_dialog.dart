import 'package:flutter/material.dart';
import 'calendar_models.dart';

class CalendarClassScheduleDialog extends StatefulWidget {
  const CalendarClassScheduleDialog({super.key, required this.classPeriods});

  final List<ClassPeriod> classPeriods;

  static Future<List<ClassPeriod>?> show(
    BuildContext context, {
    required List<ClassPeriod> classPeriods,
  }) {
    return showDialog<List<ClassPeriod>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CalendarClassScheduleDialog(classPeriods: classPeriods),
      ),
    );
  }

  @override
  State<CalendarClassScheduleDialog> createState() =>
      _CalendarClassScheduleDialogState();
}

class _CalendarClassScheduleDialogState
    extends State<CalendarClassScheduleDialog> {
  late List<ClassPeriod> _periods;

  @override
  void initState() {
    super.initState();
    _periods = widget.classPeriods.map((period) => period.copyWith()).toList();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _saveSchedule() {
    Navigator.of(context).pop(_periods);
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 560, maxWidth: 700),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CLASS SCHEDULE',
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit your weekly class periods',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF753896),
                    fontSize: 8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children:
                    [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday',
                    ].map((day) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _editDay(day),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF381B4B),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 14,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    day.substring(0, 3).toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Color(0xFF381B4B),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(child: _buildPeriodsSummaryCard(day)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF381B4B),
                        width: 2,
                      ),
                      foregroundColor: const Color(0xFF381B4B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _periods.clear();
                      });
                    },
                    child: const Text('RESET ALL'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF753896),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    onPressed: _saveSchedule,
                    child: const Text(
                      'SAVE CLASS\nSCHEDULE',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodsSummaryCard(String day) {
    final list = _periods.where((p) => p.day == day).toList();
    if (list.isEmpty) {
      return const Text(
        'Tap to add periods',
        style: TextStyle(
          fontFamily: 'PressStart2P',
          color: Color(0xFF753896),
          fontSize: 9,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF381B4B), width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  padding: const EdgeInsets.only(right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(p.startTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          color: Color(0xFF381B4B),
                          fontSize: 8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTime(p.endTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          color: Color(0xFF381B4B),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    p.subject.isEmpty ? 'No subject' : p.subject,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Color(0xFF753896),
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isEndTimeValid(TimeOfDay start, TimeOfDay end) {
    return end.hour > start.hour ||
        (end.hour == start.hour && end.minute > start.minute);
  }

  Future<void> _editDay(String day) async {
    final rowErrors = <int, String?>{};
    final List<ClassPeriod> dayPeriods = _periods
        .where((p) => p.day == day)
        .map((p) => p.copyWith())
        .toList();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF5E2C4),
                border: Border.all(color: const Color(0xFF381B4B), width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$day Schedule',
                          style: const TextStyle(
                            fontFamily: 'PressStart2P',
                            color: Color(0xFF381B4B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF381B4B),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...dayPeriods.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final period = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFF381B4B),
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                initialValue: period.subject,
                                onChanged: (value) {
                                  setModalState(() {
                                    dayPeriods[idx] = period.copyWith(
                                      subject: value,
                                    );
                                  });
                                },
                                style: const TextStyle(
                                  fontFamily: 'PressStart2P',
                                  color: Color(0xFF381B4B),
                                  fontSize: 9,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Subject',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'PressStart2P',
                                    color: Color(0xFFB38BC2),
                                    fontSize: 8,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF381B4B),
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF381B4B),
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF753896),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF753896),
                                          width: 2,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF753896,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final result = await showTimePicker(
                                          context: context,
                                          initialTime: period.startTime,
                                        );
                                        if (result != null) {
                                          setModalState(() {
                                            dayPeriods[idx] = period.copyWith(
                                              startTime: result,
                                            );
                                            if (!_isEndTimeValid(
                                              result,
                                              dayPeriods[idx].endTime,
                                            )) {
                                              rowErrors[idx] =
                                                  'End time must be after start time';
                                            } else {
                                              rowErrors.remove(idx);
                                            }
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Start ${_formatTime(period.startTime)}',
                                        style: const TextStyle(
                                          fontFamily: 'PressStart2P',
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF753896),
                                          width: 2,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF753896,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final result = await showTimePicker(
                                          context: context,
                                          initialTime: period.endTime,
                                        );
                                        if (result != null) {
                                          setModalState(() {
                                            if (!_isEndTimeValid(
                                              period.startTime,
                                              result,
                                            )) {
                                              rowErrors[idx] =
                                                  'End time must be after start time';
                                            } else {
                                              dayPeriods[idx] = period.copyWith(
                                                endTime: result,
                                              );
                                              rowErrors.remove(idx);
                                            }
                                          });
                                        }
                                      },
                                      child: Text(
                                        'End ${_formatTime(period.endTime)}',
                                        style: const TextStyle(
                                          fontFamily: 'PressStart2P',
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFF6B431A),
                                    ),
                                    onPressed: () {
                                      setModalState(() {
                                        dayPeriods.removeAt(idx);
                                        rowErrors.remove(idx);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (rowErrors[idx] != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  rowErrors[idx]!,
                                  style: const TextStyle(
                                    fontFamily: 'PressStart2P',
                                    color: Color(0xFFB00020),
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF753896),
                          ),
                          onPressed: () {
                            setModalState(() {
                              dayPeriods.add(
                                ClassPeriod(
                                  day: day,
                                  subject: '',
                                  startTime: const TimeOfDay(
                                    hour: 7,
                                    minute: 0,
                                  ),
                                  endTime: const TimeOfDay(hour: 8, minute: 0),
                                ),
                              );
                            });
                          },
                          child: const Text('Add Period'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF381B4B),
                          ),
                          onPressed: () {
                            setState(() {
                              _periods.removeWhere((p) => p.day == day);
                              _periods.addAll(dayPeriods);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save Day'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}