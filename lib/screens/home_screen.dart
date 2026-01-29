// SAME LOGIC — ONLY UI IMPROVED
// (this is your final polished Home Screen)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import 'calendar_screen.dart';
import 'stats_screen.dart';

enum FilterType { all, completed, pending }

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Habit> habits = [];
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  FilterType currentFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'habits',
      habits.map((h) => jsonEncode(h.toMap())).toList(),
    );
  }

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('habits');

    if (data != null) {
      habits.clear();
      habits.addAll(data.map((e) => Habit.fromMap(jsonDecode(e))));
    } else {
      habits.addAll([
        Habit(name: 'Drink Water', note: '8 glasses'),
        Habit(name: 'Exercise', note: '30 minutes'),
        Habit(name: 'Read', note: '10 pages'),
      ]);
    }
    setState(() {});
  }

  List<Habit> get filteredHabits {
    List<Habit> list = [...habits];
    if (currentFilter == FilterType.completed) {
      list = list.where((h) => h.history.last).toList();
    } else if (currentFilter == FilterType.pending) {
      list = list.where((h) => !h.history.last).toList();
    }
    list.sort(
      (a, b) =>
          (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0),
    );
    return list;
  }

  double get progress {
    if (habits.isEmpty) return 0;
    return habits.where((h) => h.history.last).length /
        habits.length;
  }

  void addHabit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Habit name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration:
                  const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              habits.add(Habit(
                name: nameController.text,
                note: noteController.text,
              ));
              nameController.clear();
              noteController.clear();
              saveHabits();
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CalendarScreen(habits: habits),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StatsScreen(habits: habits),
              ),
            ),
          ),
          IconButton(
            icon:
                Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // Gradient Progress Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.purple],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today’s Progress',
                    style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.white),
                ),
                const SizedBox(height: 6),
                Text('${(progress * 100).toInt()}% completed',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredHabits.length,
              itemBuilder: (_, i) {
                final habit = filteredHabits[i];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: IconButton(
                      icon: Icon(
                        habit.isPinned
                            ? Icons.star
                            : Icons.star_border,
                        color:
                            habit.isPinned ? Colors.orange : null,
                      ),
                      onPressed: () {
                        habit.isPinned = !habit.isPinned;
                        saveHabits();
                        setState(() {});
                      },
                    ),
                    title: Text(habit.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      habit.note.isNotEmpty
                          ? habit.note
                          : '🔥 ${habit.streak} day streak',
                    ),
                    trailing: Checkbox(
                      value: habit.history.last,
                      onChanged: (v) {
                        habit.history = [
                          ...habit.history.sublist(1),
                          v!,
                        ];
                        saveHabits();
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addHabit,
        icon: const Icon(Icons.add),
        label: const Text('Add Habit'),
      ),
    );
  }
}
