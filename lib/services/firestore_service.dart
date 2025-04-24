import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/task.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'tasks';

  Stream<List<Task>> listenToTasks(String userId) {
    return _db.collection(_collection)
        .where('sharedWith', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
          snapshot.docs.map((doc) => Task.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> addTask(Task task) async {
    final data = task.toJson();
    data['timestamp'] = FieldValue.serverTimestamp();
    await _db.collection(_collection).doc(task.id).set(data);
  }

  Future<void> updateTask(Task task) async {
    final data = task.toJson();
    data['timestamp'] = FieldValue.serverTimestamp(); // Optionally update time
    await _db.collection(_collection).doc(task.id).update(data);
  }
}
