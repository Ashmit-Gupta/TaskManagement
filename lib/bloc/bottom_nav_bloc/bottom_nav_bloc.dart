import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, int> {
  BottomNavBloc() : super(0) {
    on<BottomNavEvent>((event, emit) {
      switch(event){
        case BottomNavEvent.Add:
          emit(0);
          break;
        case BottomNavEvent.SideBar:
          emit(1);
          break;
        case BottomNavEvent.Calender:
          emit(2);
          break;
      }
    });
  }
}
