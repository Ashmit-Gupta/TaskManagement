// import 'package:bloc/bloc.dart';
// import 'package:logger/logger.dart';
// import 'package:meta/meta.dart';
// import 'package:task_management_app/models/task_model.dart';
// import 'package:task_management_app/repository/shared_pref_repository.dart';
// import 'package:task_management_app/repository/task_repository.dart';
// import '../../models/error_model.dart';
//
// part 'task_event.dart';
// part 'task_state.dart';
//
// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   List<TaskModel> _task = [];
//
//   final TaskRepository taskRepository;
//   final SharedPrefStorage sharedPrefStorage;
//
//   TaskBloc(this.taskRepository, this.sharedPrefStorage) : super(TaskInitial()) {
//     on<CreateTask>(_onCreateTask);
//     on<GetAllTasks>(_onGetAllTasks);
//     on<UpdateTask>(_onUpdateTask);
//     on<DeleteTask>(_onDeleteTask);
//   }
//
//   /// Unified function to handle task operations
//   Future<void> _handleTaskOperation(
//       Emitter<TaskState> emit, Future<ErrorModel> Function(String) operation) async {
//     emit(TaskLoading());
//     try {
//       final token = await sharedPrefStorage.getToken();
//       final response = await operation(token);
//       if (response.error != null) {
//         emit(TaskFailure(message: response.error!));
//       } else {
//         emit(TaskSuccess());  // Ensures UI updates only when necessary
//       }
//     } catch (e, stackTrace) {
//       print("TaskBloc Error: $e \nStackTrace: $stackTrace");
//       emit(TaskFailure(message: "An unexpected error occurred."));
//     }
//   }
//
//   /// Fetches all tasks from the repository
//   Future<void> _onGetAllTasks(GetAllTasks event, Emitter<TaskState> emit) async {
//     emit(TaskLoading());
//     try {
//       Logger().i("in the get all task operation");
//       final token = await sharedPrefStorage.getToken();
//       final response = await taskRepository.getTasks(token);
//       Logger().i("in the get all task operation and hers the data :${response.data}");
//       if (response.error != null) {
//         print("log error in getting the task");
//         emit(TaskFailure(message: response.error!));
//       } else {
//         print("log success in getting the task");
//         emit(TaskLoaded(tasks: response.data));
//       }
//     } catch (e, stackTrace) {
//       print("Error fetching tasks: $e \nStackTrace: $stackTrace");
//       emit(TaskFailure(message: "Failed to load tasks."));
//     }
//   }
//
//   /// Creates a new task
//   Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
//     Logger().i("in the create task operation");
//     await _handleTaskOperation(emit, (token) => taskRepository.createTask(event.task, token));
//   }
//
//   /// Updates an existing task
//   Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
//     Logger().i("in the update task operation");
//     await _handleTaskOperation(
//         emit, (token) => taskRepository.updateTask(token, event.id, event.updatedTask));
//   }
//
//   /// Deletes a task
//   Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
//     Logger().i("in the delete task operation");
//     await _handleTaskOperation(emit, (token) => taskRepository.deleteTask(token, event.id));
//   }
// }
