import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/repository/shared_pref_repository.dart';
import 'package:task_management_app/repository/task_repository.dart';
import 'package:task_management_app/widgets/custom_list_tile.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../models/task_model.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(title: const Text("Tasks")),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _TaskScreenBody(),
      ),
    );
  }
}

class _TaskScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(TaskRepository(), SharedPrefStorage())..add(GetAllTasks()),
      child: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskFailure) {
            Logger().e("Error: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoaded) {
              return _TaskList(tasks: state.tasks);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        // return _TaskListItem(task: task);
        return CustomListTile(task: task);
      },
    );
  }
}