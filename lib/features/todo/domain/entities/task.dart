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

  Task copyWith({
    String? id,
    String? name,
    DateTime? dueDate,
    int? colorValue,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      colorValue: colorValue ?? this.colorValue,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, name, dueDate, colorValue, isCompleted];
}
