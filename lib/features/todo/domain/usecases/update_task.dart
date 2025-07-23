import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(Task task) async {
    if (task.name.trim().isEmpty) {
      throw Exception('Task name cannot be empty.');
    }

    await repository.updateTask(task);
  }
}
