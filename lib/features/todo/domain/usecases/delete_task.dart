import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call({required String id, required bool isCompleted}) async {
    if (!isCompleted) {
      throw Exception('Only completed tasks can be deleted.');
    }

    await repository.deleteTask(id);
  }
}
