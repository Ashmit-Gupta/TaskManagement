part of 'task_bloc.dart';

sealed class TaskEvent {}

final class CreateTask extends TaskEvent{
  final TaskModel task;

  CreateTask({required this.task});
}

final class DeleteTask extends TaskEvent{
  final String id;
DeleteTask({required this.id});
}

final class UpdateTask extends TaskEvent{
  final String id;
  final TaskModel updatedTask;
  UpdateTask({required this.updatedTask , required this.id});
}

final class GetAllTasks extends TaskEvent{

}