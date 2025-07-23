import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../domain/entities/task.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

import 'package:uuid/uuid.dart';

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          } else if (state is TodoLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet.'));
            }
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      context.read<TodoBloc>().add(
                        UpdateTaskEvent(
                          task.copyWith(isCompleted: value ?? false),
                        ),
                      );
                    },
                  ),
                  title: Text(
                    task.name,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: Color(task.colorValue),
                    ),
                  ),
                  subtitle: task.dueDate != null
                      ? Text(
                          'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(
                        DeleteTaskEvent(task.id, task.isCompleted),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskCreator(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openTaskCreator(BuildContext context) {
    final nameController = TextEditingController();
    DateTime? selectedDueDate;
    Color selectedColor = Colors.blue;
    final uuid = const Uuid();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsetsGeometry.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Task Name'),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Task Color: '),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text('Pick a color'),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: selectedColor,
                                    onColorChanged: (color) {
                                      setState(() => selectedColor = color);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: selectedColor,
                          radius: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Due Date: '),
                      const SizedBox(width: 8),
                      Text(
                        selectedDueDate != null
                            ? selectedDueDate!.toLocal().toString().split(
                                ' ',
                              )[0]
                            : 'None',
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 1),
                            ),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() => selectedDueDate = pickedDate);
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task name cannot be empty'),
                          ),
                        );
                        return;
                      }

                      final task = Task(
                        id: uuid.v4(),
                        name: name,
                        colorValue: Colors.blue.value,
                        dueDate: null,
                        isCompleted: false,
                      );

                      context.read<TodoBloc>().add(AddTaskEvent(task));
                      Navigator.pop(context);
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
