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
        onPressed: () async {
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (context) => const AddGoalScreen()),
          );
          if (result != null) {
            setState(() {
              goals.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// STATIC: second screen for adding a goal
class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  // LOGIC: text controllers and error messages
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  String? subjectError;
  String? hoursError;

  // LOGIC: validate, then return the new goal with Navigator.pop
  void saveGoal() {
    final String subject = subjectController.text.trim();
    final int? hours = int.tryParse(hoursController.text.trim());

    setState(() {
      subjectError = subject.isEmpty ? 'Subject must not be empty' : null;
      hoursError = (hours == null || hours <= 0)
          ? 'Hours must be a number greater than 0'
          : null;
    });

    if (subjectError == null && hoursError == null) {
      Navigator.pop(context, {
        'subject': subject,
        'hours': hours!,
        'done': false,
      });
    }
  }

  // LOGIC: dispose the controllers when the screen closes
  @override
  void dispose() {
    subjectController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: App bar
      appBar: AppBar(title: const Text('Add Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                errorText: subjectError,
              ),
            ),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hours',
                errorText: hoursError,
              ),
            ),
            const SizedBox(height: 16),
            // CONNECTION: Save button calls saveGoal
            ElevatedButton(onPressed: saveGoal, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
