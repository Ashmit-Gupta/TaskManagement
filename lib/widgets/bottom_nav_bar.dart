import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/widgets/task_bottom_sheet.dart';

import '../bloc/bottom_nav_bloc/bottom_nav_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, int>(
      builder: (context, currentIndex) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            // When "add" is tapped, open the task bottom sheet.
            if (index == 1) {
              showTaskSheet(context);
            }
            context.read<BottomNavBloc>().add(BottomNavEvent.values[index]);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "",
            ),
          ],
        );
      },
    );
  }
}