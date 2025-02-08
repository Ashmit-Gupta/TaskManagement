import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management_app/bloc/auth_bloc/auth_bloc.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
    if (state is AuthSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful"),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false, // Removes all previous routes
      );
    }
  },
  builder: (context, state) {
    if(state is AuthLoading){
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
                decoration: InputDecoration(
                    labelText: 'Email Address', hintText: 'Laura@gmail.com'),controller: _emailController,),
            TextField(
              controller: _pwdController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {}, child: Text("Forgot password?"))),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLoginRequested(_emailController.text.trim(), _pwdController.text));
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                child: Text("Log in")),
            SizedBox(height: 10),
            Text("or log in with"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: SvgPicture.asset('assets/svgs/f_logo.svg',height: 25,), onPressed: () {}),
                IconButton(icon: SvgPicture.asset('assets/svgs/g_logo.svg',height: 25), onPressed: () {}),
                IconButton(icon: SvgPicture.asset('assets/svgs/a_logo.svg',height: 22), onPressed: () {}),
              ],
            ),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text("Don't have an account? Get started!"))
          ],
        ),
      ),
    );
  },
);
  }
}
