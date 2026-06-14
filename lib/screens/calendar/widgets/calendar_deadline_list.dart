import 'package:flutter/material.dart';
import '../calendar_controller.dart';
import '../calendar_models.dart';

class CalendarDeadlineList extends StatelessWidget {
  final CalendarController controller;
  final Future<void> Function(
    BuildContext context,
    int index,
    Deadline deadline,
  )
  onEditDeadline;
  final Function(int index)? onDeleteDeadline;

  const CalendarDeadlineList({
    super.key,
    required this.controller,
    required this.onEditDeadline,
    this.onDeleteDeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF381B4B), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UPCOMING DEADLINES',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Color(0xFF381B4B),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...controller.getSortedDeadlines().asMap().entries.map((entry) {
            final sortedIndex = entry.key;
            final deadline = entry.value;
            final originalIndex = controller.deadlines.indexOf(deadline);
            return Padding(
              padding: EdgeInsets.only(
                bottom: sortedIndex < controller.deadlines.length - 1 ? 12 : 0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E2C4),
                  border: Border.all(color: const Color(0xFF753896), width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      deadline.icon,
                      color: const Color(0xFF753896),
                      size: 14,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deadline.title,
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF381B4B),
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${deadline.studyHub} · ${deadline.studyMethod}',
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF753896),
                              fontSize: 6,
                            ),
                          ),
                          if (deadline.notes.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              deadline.notes,
                              style: const TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Color(0xFF6B431A),
                                fontSize: 6,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            deadline.date,
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF753896),
                              fontSize: 7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF753896),
                        size: 16,
                      ),
                      onPressed: () =>
                          onEditDeadline(context, originalIndex, deadline),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xFF6B431A),
                        size: 16,
                      ),
                      onPressed: () {
                        controller.deleteDeadline(originalIndex);
                        onDeleteDeadline?.call(originalIndex);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}