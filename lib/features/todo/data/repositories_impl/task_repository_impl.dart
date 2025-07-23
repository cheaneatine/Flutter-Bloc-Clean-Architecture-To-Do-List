import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Task>> getTasks() async {
    return await remoteDataSource.getTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    await remoteDataSource.addTask(_toModel(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await remoteDataSource.updateTask(_toModel(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await remoteDataSource.deleteTask(id);
  }

  TaskModel _toModel(Task task) {
    return TaskModel(
      id: task.id,
      name: task.name,
      dueDate: task.dueDate,
      colorValue: task.colorValue,
      isCompleted: task.isCompleted,
    );
  }
}
