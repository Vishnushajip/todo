import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  List<String> sharedWith;
  String ownerId;
  Timestamp? timestamp;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.sharedWith,
    required this.ownerId,
    this.timestamp,
  });

  factory Task.fromJson(Map<String, dynamic> json, String id) => Task(
    id: id,
    title: json['title'],
    description: json['description'],
    sharedWith: List<String>.from(json['sharedWith']),
    ownerId: json['ownerId'],
    timestamp: json['timestamp'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'sharedWith': sharedWith,
    'ownerId': ownerId,
    'timestamp': timestamp,
  };
}
