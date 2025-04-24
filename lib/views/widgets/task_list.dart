import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  TaskList(this.tasks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        final task = tasks[i];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
        );
      },
    );
  }
}
