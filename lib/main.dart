import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:task_management_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_management_app/common/colors.dart';
import 'package:task_management_app/repository/auth_repository.dart';
import 'package:task_management_app/repository/shared_pref_repository.dart';
import 'package:task_management_app/repository/task_repository.dart';
import 'package:task_management_app/screens/login_screen.dart';
import 'package:task_management_app/screens/register_screen.dart';
import 'package:task_management_app/screens/splash_screen.dart';

import 'bloc/auth_bloc/auth_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>AuthBloc(AuthRepository(sharedPrefStorage: SharedPrefStorage()))),
        BlocProvider(create: (_)=> TaskBloc(TaskRepository(),SharedPrefStorage())),
        BlocProvider(create: (_)=>BottomNavBloc()),
      ],
      child: MaterialApp(
        // Colors.deepPurpleAccent
        theme: ThemeData(primaryColor: kPrimaryTheme,primarySwatch: Colors.purple),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}