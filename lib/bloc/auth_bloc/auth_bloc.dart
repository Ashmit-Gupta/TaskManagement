import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final Logger _logger = Logger();

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final validationError = _validateCredentials(event.email, event.password);
      if (validationError != null) {
        emit(AuthFailure(validationError));
        return;
      }

      _logger.i("Registering: ${event.email}");
      final response = await authRepository.register(event.name, event.email, event.password);
      response.error != null ? emit(AuthFailure(response.error!)) : emit(AuthSuccess());
    } catch (e) {
      _logger.e("Registration failed: $e");
      emit(AuthFailure("An unexpected error occurred."));
    }
  }

  Future<void> _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final validationError = _validateCredentials(event.email, event.password);
      if (validationError != null) {
        emit(AuthFailure(validationError));
        return;
      }
      _logger.i("Logging in: ${event.email}");
      final response = await authRepository.login(event.email, event.password);
      response.error != null ? emit(AuthFailure(response.error!)) : emit(AuthSuccess());
    } catch (e) {
      _logger.e("Login failed: $e");
      emit(AuthFailure("An unexpected error occurred. $e"));
    }
  }

  Future<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      _logger.e("Logout failed: $e");
      emit(AuthFailure("An unexpected error occurred. $e"));
    }
  }

  String? _validateCredentials(String email, String password) {
    if (password.length < 6) return "Password must contain at least 6 characters";
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) return "Please enter a valid email ID";
    return null;
  }
}
