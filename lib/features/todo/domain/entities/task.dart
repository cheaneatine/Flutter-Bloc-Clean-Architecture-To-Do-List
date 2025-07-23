import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String name;
  final DateTime? dueDate;
  final int colorValue;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.name,
    this.dueDate,
    required this.colorValue,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, name, dueDate, colorValue, isCompleted];
}
