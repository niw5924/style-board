import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());

  void changeTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
