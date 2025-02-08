import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../models/task_model.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if(state is TaskInitial){
            context.read<TaskBloc>().add(GetAllTasks());
          }
          else if(state is TaskLoaded){
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.tasks[index].priority!),
                  subtitle: Text(state.tasks[index].description!),
                );
              },
            );
          }
          else if(state is TaskFailure){
            Logger().e("the error is : ${state.message}");
            return Center(
              child: Text("the error is : ${state.message}"),
            );
          }
          return Center(
            child: Text("kuch bhi nhi ho rha ibbe !!"),
          );
        }
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<TaskBloc>().add(UpdateTask(
                updatedTask: {
                  "description": "Updated task description",
                  "priority": "medium",
                  "done": true,
                  "dueDate": DateTime.now().toString(),
                }, id: '67a6d8c3280be7079ba39870',
              ));
            },
            child: Icon(Icons.update),
          ),
          const SizedBox(height: 10), // Adds spacing between buttons
          FloatingActionButton(
            onPressed: () {
              context.read<TaskBloc>().add(CreateTask(
                task: TaskModel(
                  description: "This is a testing task",
                  priority: "high",
                  done: false, // Ensure correct data type
                  dueDate: DateTime.now().add(Duration(days: 7)).toString(),
                ),
              ));
            },
            child: Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(id: "67a6d936280be7079ba39878"));
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),

      );
  }
}
