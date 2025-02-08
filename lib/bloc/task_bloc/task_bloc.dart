import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/repository/shared_pref_repository.dart';
import 'package:task_management_app/repository/task_repository.dart';
import '../../models/error_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  List<TaskModel> _tasks = [];

  final TaskRepository taskRepository;
  final SharedPrefStorage sharedPrefStorage;

  TaskBloc(this.taskRepository, this.sharedPrefStorage) : super(TaskInitial()) {
    on<CreateTask>(_onAddTask);
    on<GetAllTasks>(_onGetAllTasks);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  /// Fetches all tasks from the repository
  Future<void> _onGetAllTasks(GetAllTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final token = await sharedPrefStorage.getToken();
      final response = await taskRepository.getTasks(token);
      Logger().i("in the get all task operation and hers the data :${response.data}");

      if (response.error != null) {
        print("log error in getting the task");
        emit(TaskFailure(message: response.error!));
      } else {
        print("log success in getting the task");
        _tasks = response.data;
        emit(TaskLoaded(tasks: _tasks));
      }
    } catch (e, stackTrace) {
      print("Error fetching tasks: $e \nStackTrace: $stackTrace");
      emit(TaskFailure(message: "Failed to load tasks."));
    }
  }

  Future<void> _onAddTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
      final token = await sharedPrefStorage.getToken();
      final ErrorModel response = await taskRepository.createTask(event.task,token);
      if (response.error == null) {
        _tasks.add(event.task); // Update local list
        emit(TaskLoaded(tasks: List.from(_tasks))); // Emit updated state
      } else {
        emit(TaskFailure(message: response.error!));
      }
    }


  /// Updates an existing task
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    Logger().i("in the update task operation");
    emit(TaskLoading());
    final token = await sharedPrefStorage.getToken();
    final ErrorModel response = await taskRepository.updateTask(token,event.id,event.updatedTask,);
    if (response.error == null) {
      int index = _tasks.indexWhere((t)=> t.id == event.id);
      if(index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          id: event.id,
          dueDate: event.updatedTask.containsKey('dueDate') ? event.updatedTask['dueDate'] : _tasks[index].dueDate,
          done: event.updatedTask.containsKey('done') ? event.updatedTask['done'] : _tasks[index].done,
          description: event.updatedTask.containsKey('description') ? event.updatedTask['description'] : _tasks[index].description,
          priority: event.updatedTask.containsKey('priority') ? event.updatedTask['priority'] : _tasks[index].priority,
        );
      }
      emit(TaskLoaded(tasks: List.from(_tasks))); // Emit updated state
    } else {
      emit(TaskFailure(message: response.error!));
    }
  }
  /// Deletes a task
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    Logger().i("in the delete task operation");
    emit(TaskLoading());
    final token = await sharedPrefStorage.getToken();
    final ErrorModel response = await taskRepository.deleteTask(token,event.id);
    if (response.error == null) {
      _tasks.removeWhere((t)=> t.id == event.id); // Update local list
      emit(TaskLoaded(tasks: List.from(_tasks))); // Emit updated state
    } else {
      emit(TaskFailure(message: response.error!));
    }

  }

  @override
  void onChange(Change<TaskState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print("task bloc - change $change");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(error, stackTrace);
    print(error);
  }

}
