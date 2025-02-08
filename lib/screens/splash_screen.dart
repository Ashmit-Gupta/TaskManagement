import 'package:flutter/material.dart';
import 'package:task_management_app/repository/shared_pref_repository.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await SharedPrefStorage().getToken();
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Column(
              children: [
                Icon(Icons.check_circle, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text("Get things done.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Just a click away from planning your tasks.",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.arrow_forward, size: 32, color: Colors.blue),
                onPressed: () => Navigator.pushNamed(context, '/register'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
