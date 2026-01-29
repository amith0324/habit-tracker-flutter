import 'package:flutter/material.dart';
import '../models/habit.dart';

class CalendarScreen extends StatelessWidget {
  final List<Habit> habits;

  const CalendarScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days =
        DateTime(now.year, now.month + 1, 0).day;

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Calendar')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: days,
        itemBuilder: (_, i) {
          final completed =
              habits.any((h) => h.history.last);
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${i + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}
