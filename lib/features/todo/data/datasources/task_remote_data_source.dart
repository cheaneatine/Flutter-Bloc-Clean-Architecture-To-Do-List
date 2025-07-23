import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final CollectionReference taskCollection = FirebaseFirestore.instance
      .collection('tasks');

  @override
  Future<List<TaskModel>> getTasks() async {
    final snapshot = await taskCollection.get();
    return snapshot.docs.map((doc) => TaskModel.fromDocument(doc)).toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await taskCollection.doc(task.id).set(task.toMap());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await taskCollection.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskCollection.doc(id).delete();
  }
}
