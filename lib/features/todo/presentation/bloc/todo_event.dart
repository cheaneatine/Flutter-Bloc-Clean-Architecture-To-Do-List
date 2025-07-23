import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTaskEvent extends TodoEvent {
  final Task task;

  const AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TodoEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TodoEvent {
  final String taskId;
  final bool isCompleted;

  const DeleteTaskEvent(this.taskId, this.isCompleted);

  @override
  List<Object?> get props => [taskId, isCompleted];
}
