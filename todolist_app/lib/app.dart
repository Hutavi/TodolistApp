import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/blocs/tasks/tasks_bloc.dart';
import 'package:todolist_app/data/local/data_sources/tasks_data_provider.dart';
import 'package:todolist_app/data/repository/task_repository.dart';
import 'package:todolist_app/routers/route.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  const MyApp({
    Key? key,
    required this.preferences,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TaskRepository(
        taskDataProvider: TaskDataProvider(widget.preferences), // Sửa đổi ở đây
      ),
      child: BlocProvider(
        create: (context) => TasksBloc(context.read<TaskRepository>()),
        child: const MaterialApp(
          title: 'Management App',
          debugShowCheckedModeBanner: false,
          // theme: AppThemes.lightTheme,
          initialRoute: '/navigation',
          // home: HomePage(),
          onGenerateRoute: AppRoute.onGenerateRoute,
        ),
      ),
    );
  }
}
