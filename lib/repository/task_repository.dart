import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/common/constants.dart';
import 'package:task_management_app/models/error_model.dart';

class TaskRepository {


  Future<ErrorModel> createTask(TaskModel task, String token) async{
    ErrorModel error = ErrorModel(error: "Something Went Wrong", data: null);
    try {
      Logger().d("log the json data for create task is :${jsonEncode(task.toJson())}");

      final response = await http.post(
          Uri.parse('$kHost/tasks'),
          headers: {'Content-Type': 'application/json', 'token': token},
          body: jsonEncode(task.toJson()));

      Logger().i("Response: ${response.statusCode} -> ${response.body}");
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ErrorModel(error: null, data: responseBody);
      } else {
        return ErrorModel(error: jsonDecode(response.body)['message'], data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }


  Future<ErrorModel> getTasks(String token) async{
    ErrorModel error = ErrorModel(error: "Something Went Wrong", data: null);
    try {
      final response = await http.get(
        Uri.parse('$kHost/tasks'),
        headers: {'Content-Type': 'application/json', 'token': token},);

      if (response.statusCode == 200) {
        Logger().i("Response from get Task: ${response.statusCode} ->${jsonDecode(response.body)['task']} and the type is : ${response.runtimeType}");

        final List<dynamic> decodeData = jsonDecode(response.body)['task'];
        List<TaskModel> taskList = [];
        for(var task in decodeData){
          taskList.add(TaskModel.fromJson(task));
        }
        print("log from getTask repo : ${taskList}");
        error =  ErrorModel(error: null, data: taskList);
      }else{
        error =ErrorModel(error: jsonDecode(response.body)['message'], data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> updateTask(String token, String id, TaskModel updatedTask) async{
    ErrorModel error = ErrorModel(error: "Something Went Wrong", data: null);
    try {
      final response = await http.patch(
        Uri.parse('$kHost/tasks/$id'),
        headers: {'Content-Type': 'application/json', 'token': token},
      body: jsonEncode(updatedTask),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        Logger().i("Response: ${response.statusCode} ->$responseBody and the type is : ${responseBody.runtimeType}");
        error =  ErrorModel(error: null, data: responseBody);
      }else{
        error =ErrorModel(error: jsonDecode(response.body)['message'], data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> deleteTask(String token, String id) async{
    ErrorModel error = ErrorModel(error: "Something Went Wrong", data: null);
    try {
      final response = await http.delete(
        Uri.parse('$kHost/tasks/$id'),
        headers: {'Content-Type': 'application/json', 'token': token},
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        Logger().i("Response: ${response.statusCode} ->$responseBody and the type is : ${responseBody.runtimeType}");
        error =  ErrorModel(error: null, data: responseBody);
      }else{
        error =ErrorModel(error: jsonDecode(response.body)['message'], data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
