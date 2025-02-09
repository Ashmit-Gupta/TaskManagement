
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<CheckLoginEvent>(_checkLoginStatus);
  }

  Future<void> _checkLoginStatus(CheckLoginEvent event , Emitter<SplashScreenState>emit) async{
    await Future.delayed(Duration(seconds: 2));

    final pref = await SharedPreferences.getInstance();
    final String? token = pref.getString('token');

    if( token != null && token.isNotEmpty){
      emit(Authenticated());
    }else{
      emit(Unauthenticated());
    }
  }
}
