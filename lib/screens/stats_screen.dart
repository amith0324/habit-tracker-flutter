import 'package:flutter/material.dart';
import '../models/habit.dart';

class StatsScreen extends StatelessWidget {
  final List<Habit> habits;

  const StatsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final total = habits.length * 7;
    final completed =
        habits.expand((h) => h.history).where((e) => e).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Stats')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Completed $completed / $total',
                style:
                    Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              value: total == 0 ? 0 : completed / total,
              strokeWidth: 10,
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}
