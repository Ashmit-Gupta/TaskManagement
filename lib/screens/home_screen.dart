import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:task_management_app/common/colors.dart';
import 'package:task_management_app/widgets/list_tile.dart';
import 'package:task_management_app/widgets/swpie_background.dart';
import 'package:task_management_app/widgets/task_bottom_sheet.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../models/task_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<BottomNavBloc, int>(
        builder: (context, currentIndex) {
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              if (index == 1) showTaskSheet(context);
              context.read<BottomNavBloc>().add(BottomNavEvent.values[index]);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
            ],
          );
        },
      ),
      appBar: AppBar(title: const Text("Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              if (state is TaskInitial) {
                context.read<TaskBloc>().add(GetAllTasks());
                return const Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                return _buildTaskList(state.tasks);
              }
              return const Center(child: Text("No tasks available!"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: ValueKey(task.id),
          background: swipeBackground(kGreenColor, Icons.edit, "Edit"),
          secondaryBackground: swipeBackground(kRedColor, Icons.delete, "Delete"),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              context.read<TaskBloc>().add(DeleteTask(id: task.id!));
              await Future.delayed(const Duration(milliseconds: 300));
              return true;
            } else {
              showTaskSheet(context, task: task);
              return false;
            }
          },
          child: CustomListTile(task: task),
        );
      },
    );
  }
}
