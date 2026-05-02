import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'get_started_state.dart';

class GetStartedCubit extends Cubit<GetStartedState> {
  GetStartedCubit() : super(GetStartedInitial());

  void getStarted() async {
    await Future.delayed(const Duration(seconds: 2));
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      emit(UnAuthenticated());
      return;
    }

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.uid)
              .get();

      if (userDoc.exists && userDoc.data() != null) {
        emit(Authenticated());
      } else {
        await FirebaseAuth.instance.signOut();
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}
