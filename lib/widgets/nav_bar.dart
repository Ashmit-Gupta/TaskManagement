import 'dart:io';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Platform.isAndroid ? 16 : 0),
      child: BottomAppBar(
        elevation: 10.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            color: Colors.deepPurpleAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                navItem(Icons.home_outlined, 0),
                navItem(Icons.message_outlined, 1),
                const Spacer(), // Keeps space for floating button
                navItem(Icons.notifications_none_outlined, 2),
                navItem(Icons.person_outline, 3), // Added Profile Icon
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Icon(
          icon,
          size: 28,
          color: pageIndex == index ? Colors.white : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}
