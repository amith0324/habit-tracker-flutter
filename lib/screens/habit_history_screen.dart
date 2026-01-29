import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitHistoryScreen extends StatelessWidget {
  final Habit habit;

  const HabitHistoryScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${habit.name} History')),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text('Day ${7 - i}'),
            trailing: Icon(
              habit.last7Days[i] ? Icons.check_circle : Icons.cancel,
              color: habit.last7Days[i] ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }
}
