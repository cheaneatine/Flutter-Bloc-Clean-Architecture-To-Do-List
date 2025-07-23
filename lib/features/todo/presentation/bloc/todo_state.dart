import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class ToDoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Task> tasks;

  const TodoLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}
