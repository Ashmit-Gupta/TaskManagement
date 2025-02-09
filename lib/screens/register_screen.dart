import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_management_app/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if(state is AuthFailure){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
    if (state is AuthSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration Successful please Login"),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
            Text("Let's get started!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Username'),controller: _nameController,),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: 'Email Address'),controller: _emailController,),
            SizedBox(height: 10),
            TextField(
              controller: _pwdController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthRegisterRequested(name: _nameController.text.trim(), email: _emailController.text.trim(), password: _pwdController.text));
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                child: Text("Sign up")),
            SizedBox(height: 10),
            Text("or sign up with"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: SvgPicture.asset('assets/svgs/f_logo.svg',height: 25,), onPressed: () {}),
                IconButton(icon: SvgPicture.asset('assets/svgs/g_logo.svg',height: 25,), onPressed: () {}),
                IconButton(icon: SvgPicture.asset('assets/svgs/a_logo.svg',height: 25,), onPressed: () {}),
              ],
            ),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text("Already have an account? Log in"))
          ],
        ),
      ),
    );
  },
);
  }
}
