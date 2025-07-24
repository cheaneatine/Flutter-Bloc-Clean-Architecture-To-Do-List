import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/todo/domain/usecases/add_task.dart';
import 'features/todo/domain/usecases/delete_task.dart';
import 'features/todo/domain/usecases/get_tasks.dart';
import 'features/todo/domain/usecases/update_task.dart';
import 'features/todo/data/datasources/task_remote_data_source.dart';
import 'features/todo/data/repositories_impl/task_repository_impl.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';
import 'features/todo/presentation/bloc/todo_event.dart';
import 'features/theme/presentation/bloc/theme_bloc.dart';
import 'features/theme/presentation/bloc/theme_event.dart';
import 'features/theme/presentation/bloc/theme_state.dart';
import 'features/todo/presentation/pages/todo_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyANOBi6_0txSWwqvb4z1Ka8iQ01Wlrvkyo",
        authDomain: "todolist-ec0af.firebaseapp.com",
        projectId: "todolist-ec0af",
        storageBucket: "todolist-ec0af.appspot.com",
        messagingSenderId: "77350362593",
        appId: "1:77350362593:web:35395f85d7cec7f22486a0",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = TaskRemoteDataSourceImpl();
    final repository = TaskRepositoryImpl(remoteDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(LoadThemeEvent())),
        BlocProvider(
          create: (_) => TodoBloc(
            getTasks: GetTasks(repository),
            addTask: AddTask(repository),
            updateTask: UpdateTask(repository),
            deleteTask: DeleteTask(repository),
          )..add(LoadTodosEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter To-Do List',
            theme: state.themeData,
            home: const ToDoHomePage(),
          );
        },
      ),
    );
  }
}
