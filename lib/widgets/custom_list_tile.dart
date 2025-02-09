import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/common/colors.dart';
import 'package:task_management_app/widgets/swipe_background.dart';
import 'package:task_management_app/widgets/task_bottom_sheet.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../models/task_model.dart';

class CustomListTile extends StatelessWidget {
  final TaskModel task;

  const CustomListTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(task.dueDate!);
    final String formattedDate = DateFormat('dd MMM').format(dateTime);

    return Dismissible(
      key: ValueKey(task.id),
      background: swipeBackground(kGreenColor, Icons.edit, "Edit"),
      secondaryBackground: swipeBackground(kRedColor, Icons.delete, "Delete"),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete task on swipe from right-to-left.
          context.read<TaskBloc>().add(DeleteTask(id: task.id!));
          // Allow the dismiss animation to complete.
          await Future.delayed(const Duration(milliseconds: 300));
          return true;
        } else {
          showTaskSheet(context, task: task);
          return false;
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 5,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _taskTileContent(context, formattedDate),),
      ),
    );
  }
Widget _taskTileContent(BuildContext context,String formattedDate){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Checkbox(
        value: task.done,
        onChanged: (value) {
          Logger().f("the value of radio is : $value");
          context.read<TaskBloc>().add(UpdateTask(
            updatedTask: task.copyWith(done: !task.done!),
            id: task.id!,
          ));
        },
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.description!,
              style: TextStyle(
                fontSize: 16,
                decoration: task.done!
                    ? TextDecoration.lineThrough
                    : null, // Strike-through if done
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 10, color: kGreyColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getPriorityColor(task.priority!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          task.priority!,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
  /// 🎨 Function to Get Priority Color
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "low":
        return kLowPriority;
      case "medium":
        return kMediumPriority;
      case "high":
        return kHighPriority;
      default:
        return Colors.grey; // Default color for unknown priority
    }
  }
}
