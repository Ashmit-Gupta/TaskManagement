import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_management_app/models/task_model.dart';

void showTaskSheet(BuildContext context, {TaskModel? task}) {
  final taskBloc = context.read<TaskBloc>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => BlocProvider.value(
  value: taskBloc,
  child: TaskSheet(task: task),
),
  );
}

class TaskSheet extends StatefulWidget {
  final TaskModel? task; // Null for new task, non-null for edit

  const TaskSheet({this.task});

  @override
  _TaskSheetState createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  final TextEditingController _descriptionController = TextEditingController();
  String _priority = 'low';
  bool _done = false;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();

    // Pre-fill fields if editing an existing task
    if (widget.task != null) {
      _descriptionController.text = widget.task!.description!;
      _priority = widget.task!.priority!;
      _done = widget.task!.done!;
      _dueDate = DateTime.tryParse(widget.task!.dueDate!);
    }
  }

  void _handleSubmit() {
    if (_descriptionController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final task = TaskModel(
      id: widget.task?.id, // Preserve ID for edits
      description: _descriptionController.text,
      dueDate: _dueDate.toString(),
      priority: _priority,
      done: _done,
    );

    if (widget.task == null) {
      context.read<TaskBloc>().add(CreateTask(task: task)); // Create Task
    } else {
      context.read<TaskBloc>().add(UpdateTask(updatedTask:task, id: widget.task!.id!)); // Edit Task
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.task == null ? "Create Task" : "Edit Task",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          // Task Description
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Task Description"),
          ),
          SizedBox(height: 12),

          // Due Date Picker
          ListTile(
            title: Text(_dueDate == null
                ? "Select Due Date"
                : "Due Date: ${_dueDate!.toLocal()}".split(' ')[0]),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() => _dueDate = pickedDate);
              }
            },
          ),

          // Priority Dropdown
          DropdownButtonFormField<String>(
            value: _priority,
            decoration: InputDecoration(labelText: "Priority"),
            items: ['low', 'medium', 'high']
                .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                .toList(),
            onChanged: (value) => setState(() => _priority = value!),
          ),
          SizedBox(height: 12),

          // Completion Checkbox
          CheckboxListTile(
            title: Text("Task Completed"),
            value: _done,
            onChanged: (value) => setState(() => _done = value ?? false),
          ),

          // Submit Button
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text(widget.task == null ? "Create Task" : "Update Task"),
          ),
        ],
      ),
    );
  }
}
