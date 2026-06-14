import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calendar_class_schedule_dialog.dart';
import 'calendar_controller.dart';
import 'calendar_schedule_dialog.dart';
import 'calendar_widgets.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg2_1.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CalendarHeader(
                    controller: controller,
                    onBackTap: () {
                      _playInteractionEffect();
                      Navigator.pop(context);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5E2C4),
                            border: Border.all(
                              color: const Color(0xFF381B4B),
                              width: 5,
                            ),
                            borderRadius: BorderRadius.zero,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xCC000000),
                                offset: Offset(6, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      size: 18,
                                      color: Color(0xFF381B4B),
                                    ),
                                    onPressed: () {
                                      _playInteractionEffect();
                                      setState(() {
                                        controller.previousMonth();
                                      });
                                    },
                                  ),
                                  Text(
                                    '${controller.monthName} ${controller.year}',
                                    style: const TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Color(0xFF381B4B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: Color(0xFF381B4B),
                                    ),
                                    onPressed: () {
                                      _playInteractionEffect();
                                      setState(() {
                                        controller.nextMonth();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: controller.weekLabels.map((day) {
                                  return SizedBox(
                                    width: 32,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'PressStart2P',
                                        color: Color(0xFF753896),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const Divider(
                                color: Color(0xFF6B431A),
                                thickness: 2,
                                height: 20,
                              ),
                              CalendarGrid(
                                controller: controller,
                                onDayTap: () {
                                  _playInteractionEffect();
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        GestureDetector(
                          onTap: () async {
                            _playInteractionEffect();
                            final deadline = await CalendarScheduleDialog.show(
                              context,
                              initialDate: controller.selectedDate,
                            );
                            if (deadline != null) {
                              controller.addDeadline(deadline);
                              setState(() {});
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF753896),
                              border: Border.all(
                                color: const Color(0xFF4C3075),
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xCC000000),
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'CREATE SCHEDULE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () async {
                            _playInteractionEffect();
                            final updatedPeriods =
                                await CalendarClassScheduleDialog.show(
                                  context,
                                  classPeriods: controller.classPeriods
                                      .map((period) => period.copyWith())
                                      .toList(),
                                );
                            if (updatedPeriods != null) {
                              controller.updateClassPeriods(updatedPeriods);
                              setState(() {});
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF381B4B),
                              border: Border.all(
                                color: const Color(0xFF4C3075),
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xCC000000),
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'CLASS SCHEDULE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        CalendarDeadlineList(
                          controller: controller,
                          onEditDeadline: (context, index, deadline) async {
                            _playInteractionEffect();
                            final updated = await CalendarScheduleDialog.show(
                              context,
                              initialDate: controller.selectedDate,
                              initialDeadline: deadline,
                            );
                            if (updated != null) {
                              controller.updateDeadline(index, updated);
                              setState(() {});
                            }
                          },
                          onDeleteDeadline: (index) {
                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}