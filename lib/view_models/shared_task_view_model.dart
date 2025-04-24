import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';

class SharedTaskViewModel extends ChangeNotifier {
  Task? task;
  bool isLoading = false;
  bool isUpdating = false;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  Future<void> fetchTask(String taskId) async {
    isLoading = true;
    notifyListeners();

    final doc = await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();
    if (doc.exists) {
      task = Task.fromJson(doc.data()!, doc.id);
      titleController.text = task!.title;
      descController.text = task!.description;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(BuildContext context) async {
    if (task == null) return;

    isUpdating = true;
    notifyListeners();

    final updatedTask = Task(
      id: task!.id,
      title: titleController.text.trim(),
      description: descController.text.trim(),
      sharedWith: task!.sharedWith,
      ownerId: task!.ownerId,
      timestamp: Timestamp.now(),
    );

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(updatedTask.id)
        .update(updatedTask.toJson());

    titleController.clear();
    descController.clear();

    isUpdating = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task updated!')),
    );
  }
}
