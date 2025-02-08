part of 'task_bloc.dart';

sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskFailure extends TaskState{
  final String message;
  TaskFailure({required this.message});

}
final class TaskLoading extends TaskState{}

final class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  TaskLoaded({required this.tasks});
}
