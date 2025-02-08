part of 'auth_bloc.dart';

sealed class AuthEvent {

}

final class AuthLoginRequested extends AuthEvent{
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);
}

final class AuthRegisterRequested extends AuthEvent{
  final String name;
  final String email;
  final String password;

  AuthRegisterRequested({required this.name,required this.email,required this.password});
}

final class AuthLogoutRequested extends AuthEvent{

}
