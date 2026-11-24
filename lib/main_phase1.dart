import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// STATIC: app root
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // STATIC: app bar
        appBar: AppBar(title: const Text('My Study Planner')),
        // STATIC: goals list
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // STATIC: heading
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'My Goals',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            // STATIC: goal cards
            Card(
              child: ListTile(
                title: Text('Web Technology'),
                subtitle: Text('hours'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('IT Law And Business Ethics'),
                subtitle: Text('5 hours'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('English'),
                subtitle: Text('3 hours'),
              ),
            ),
          ],
        ),
        // STATIC: floating action button
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
