import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';

import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TodoBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(ToDoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      final tasks = await getTasks();
      emit(TodoLoaded(tasks));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TodoState> emit) async {
    try {
      await addTask(event.task);
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await updateTask(event.task);
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await deleteTask(id: event.taskId, isCompleted: event.isCompleted);
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
