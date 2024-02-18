import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  final int initialTab;
  const TaskPage({super.key, this.initialTab = 0});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                    20, 50, 10, 20), // Đặt lề cho Container
                child: const Text(
                  "Task",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
