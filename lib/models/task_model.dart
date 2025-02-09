import 'dart:convert';
/// _id : "67a6d859280be7079ba39867"
/// userId : "67a6d524a50c1bfc6c058b6c"
/// dueDate : "2025-06-15T12:00:00.000Z"
/// done : false
/// description : "Task with a short-term future due date"
/// priority : "low"
/// createdAt : "2025-02-08T04:06:49.037Z"
/// updatedAt : "2025-02-08T04:06:49.037Z"
/// __v : 0

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));
String taskModelToJson(TaskModel data) => json.encode(data.toJson());
class TaskModel {
  TaskModel({
      String? id, 
      String? userId, 
      String? dueDate, 
      bool? done, 
      String? description, 
      String? priority, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _userId = userId;
    _dueDate = dueDate;
    _done = done;
    _description = description;
    _priority = priority;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  TaskModel.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _dueDate = json['dueDate'];
    _done = json['done'];
    _description = json['description'];
    _priority = json['priority'];
  _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _userId;
  String? _dueDate;
  bool? _done;
  String? _description;
  String? _priority;
  String? _createdAt;
  String? _updatedAt;
  int? _v;
TaskModel copyWith({  String? id,
  String? userId,
  String? dueDate,
  bool? done,
  String? description,
  String? priority,
  String? createdAt,
  String? updatedAt,
  int? v,
}) => TaskModel(  id: id ?? _id,
  userId: userId ?? _userId,
  dueDate: dueDate ?? _dueDate,
  done: done ?? _done,
  description: description ?? _description,
  priority: priority ?? _priority,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get dueDate => _dueDate;
  bool? get done => _done;
  String? get description => _description;
  String? get priority => _priority;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['dueDate'] = _dueDate;
    map['done'] = _done;
    map['description'] = _description;
    map['priority'] = _priority;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}