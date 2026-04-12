import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_clinic/core/errors/failures.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';
import 'package:tree_clinic/features/auth/domain/repo/autn_firebase_service.dart';

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signup(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
            'fullname': user.name,
            'email': user.email,
            'phone': user.phone,
            'type': user.type,
            'password': user.password,
            'confirmpassword': user.confirmPassword,
          });
      return const Right('Sign up was successfull');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return left(message);
    }
  }

  @override
  Future<Either> signIn(UserSigninModel user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return const Right("Sign in was successfull");
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'wrong password provided for that user';
      }
      return left(message);
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return Left(ServerFailure("User not found"));
      }

      return Right(UserModel.fromJson(doc.data()!));
    } catch (e) {
      return Left(ServerFailure("There was an error"));
    }
  }
}
