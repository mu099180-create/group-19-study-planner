import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// STATIC: app root
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudyPlannerScreen(),
    );
  }
}

// STATIC: main screen (now stateful so the UI can react to changes)
class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  // LOGIC: goals data, each goal has: subject, hours, done
  final List<Map<String, dynamic>> goals = [
    {'subject': 'Web Technology', 'hours': 4, 'done': false},
    {'subject': 'IT Law And Business Ethics', 'hours': 5, 'done': false},
    {'subject': 'English', 'hours': 3, 'done': false},
  ];

  // LOGIC: marks a goal as done or not done
  void toggleGoal(int index) {
    setState(() {
      goals[index]['done'] = !goals[index]['done'];
    });
  }

  // LOGIC: removes a goal from the list
  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  // LOGIC: adds a sample goal (will be replaced by a form in Phase 4)
  void addSampleGoal() {
    setState(() {
      goals.add({
        'subject': 'New Subject ${goals.length + 1}',
        'hours': 2,
        'done': false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: app bar
      appBar: AppBar(title: const Text('My Study Planner')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATIC: heading
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'My Goals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          // STATIC: goals list built from data
          Expanded(
            child: ListView.builder(
              // CONNECTION: the UI reads its items from the goals data
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final bool isDone = goal['done'];
                return Card(
                  child: ListTile(
                    onTap: () => toggleGoal(index),
                    leading: Checkbox(
                      value: isDone,
                      onChanged: (_) => toggleGoal(index),
                    ),
                    title: Text(
                      goal['subject'],
                      style: TextStyle(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Text('${goal['hours']} hours'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteGoal(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // STATIC: floating action button
      floatingActionButton: FloatingActionButton(
        // CONNECTION: the button calls the logic function
        onPressed: addSampleGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
