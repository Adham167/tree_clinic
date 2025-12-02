import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'get_started_state.dart';

class GetStartedCubit extends Cubit<GetStartedState> {
  GetStartedCubit() : super(GetStartedInitial());

  void getStarted() async {
    await Future.delayed(Duration(seconds: 5));
    if (FirebaseAuth.instance.currentUser != null) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
