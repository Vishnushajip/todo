import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/services/firestore_service.dart';

class TaskViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks(String userId) async {
    _firestore.listenToTasks(userId).listen((event) {
      _tasks = event;
      notifyListeners();
    });
  }

  Future<void> addTask(Task task) async {
    await _firestore.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _firestore.updateTask(task);
  }

  Future<void> shareTask(Task task, String email) async {
    task.sharedWith.add(email);
    await updateTask(task);
  }
}
