import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//STATIC: Main application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My study Planner',
      home: StudyPlanner(),
    );
  }
}

// STATIC: reusable statistic card
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 24)),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// STATIC: Home screen
class StudyPlanner extends StatefulWidget {
  const StudyPlanner({super.key});
  @override
  State<StudyPlanner> createState() => _StudyPlannerState();
}

class _StudyPlannerState extends State<StudyPlanner> {
  // LOGIC: Study goals
  List<Map<String, dynamic>> goals = [
    {'subject': 'Flutter', 'hours': 3, 'done': false},
    {'subject': 'Web Technology', 'hours': 4, 'done': false},
    {'subject': 'Software Architecture', 'hours': 2, 'done': false},
  ];
  //LOGIC: total hours
  int get totalHours =>
      goals.fold(0, (sum, goal) => sum + (goal['hours'] as int));
  //LOGIC: completed goals count
  int get completedCount => goals.where((goal) => goal['done'] == true).length;
  //LOGIC: remaining goals count
  int get remainingCount => goals.length - completedCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: App bar
      appBar: AppBar(
        title: const Text('My Study Planner'),
        backgroundColor: Colors.blue,
      ),
      // DYNAMIC: Study goals
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(title: 'Total hours', value: '$totalHours'),
              ),
              Expanded(
                child: StatCard(
                  title: 'Completed goals',
                  value: '$completedCount',
                ),
              ),
              Expanded(
                child: StatCard(
                  title: 'Remaining goals',
                  value: '$remainingCount',
                ),
              ),
            ],
          ),
          const Text('My Study Goals', style: TextStyle(fontSize: 24)),
          Expanded(
            child: goals.isEmpty
                ? const Center(child: Text('No goals yet. Tap + to add one!'))
                : ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: CheckboxListTile(
                          title: Text(
                            goals[index]['subject'],
                            style: TextStyle(
                              decoration: goals[index]['done']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text('${goals[index]['hours']} hours'),
                          value: goals[index]['done'],
                          onChanged: (value) {
                            setState(() {
                              goals[index]['done'] = value!;
                            });
                          },
                          secondary: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                goals.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // DYNAMIC: Add button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String subject = '';
          String studyHours = '';

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Study Goal'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Subject'),
                      onChanged: (value) {
                        subject = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Hours'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        studyHours = value;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (subject.trim().isNotEmpty &&
                          (int.tryParse(studyHours) ?? 0) > 0) {
                        setState(() {
                          goals.add({
                            'subject': subject.trim(),
                            'hours': int.parse(studyHours),
                            'done': false,
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
