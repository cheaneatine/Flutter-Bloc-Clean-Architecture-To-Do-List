import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../todo/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    super.dueDate,
    required super.colorValue,
    super.isCompleted = false,
  });

  factory TaskModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      id: doc.id,
      name: data['name'],
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      colorValue: data['colorValue'] ?? 0xFF2196f3,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dueDate': dueDate,
      'colorValue': colorValue,
      'isCompleted': isCompleted,
    };
  }
}
