part of 'splash_screen_bloc.dart';

sealed class SplashScreenState {}

final class SplashScreenInitial extends SplashScreenState {}

final class Authenticated extends SplashScreenState {}

final class Unauthenticated extends SplashScreenState {}
