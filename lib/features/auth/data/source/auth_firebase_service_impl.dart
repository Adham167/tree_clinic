import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set(user.toProfileJson(), SetOptions(merge: true));
      return const Right('Sign up was successful');
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to create the account. Please try again.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return left(message);
    } catch (e) {
      return left('Unable to create the account. Please try again.');
    }
  }

  @override
  Future<Either> signIn(UserSigninModel user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return const Right("Sign in was successful");
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to sign in. Please check your credentials.';
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      return left(message);
    } catch (e) {
      return left('Unable to sign in. Please try again.');
    }
  }

  @override
  Future<Either> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      if (!googleSignIn.supportsAuthenticate()) {
        return left('Google sign-in is not supported on this platform.');
      }

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        return left('Google sign-in did not return a valid identity token.');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return left('Google sign-in failed. Please try again.');
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser.uid)
          .set({
            'fullname':
                firebaseUser.displayName ?? googleUser.displayName ?? '',
            'email': firebaseUser.email ?? googleUser.email,
            'phone': firebaseUser.phoneNumber ?? '',
            'type': 'Farmer',
          }, SetOptions(merge: true));

      return const Right('Google sign-in was successful');
    } on GoogleSignInException catch (e) {
      if (defaultTargetPlatform == TargetPlatform.android &&
          (e.description?.contains('serverClientId must be provided on Android') ??
              false)) {
        return left(
          'Google sign-in is not configured for Android yet. Add a Web OAuth client in Firebase and re-download google-services.json, or provide GOOGLE_SERVER_CLIENT_ID.',
        );
      }
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return left('Google sign-in was cancelled.');
      }
      if (e.code == GoogleSignInExceptionCode.uiUnavailable) {
        return left('Google sign-in UI is not available on this device.');
      }
      return left(
        e.description ??
            'Google sign-in failed. Check Google OAuth setup and try again.',
      );
    } on FirebaseAuthException catch (e) {
      return left(_googleFirebaseMessage(e));
    } catch (e) {
      return left('Google sign-in failed. Please try again.');
    }
  }

  String _googleFirebaseMessage(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return 'This email is already linked to another sign-in method.';
    }
    if (e.code == 'invalid-credential') {
      return 'Google returned invalid credentials. Please try again.';
    }
    if (e.code == 'network-request-failed') {
      return 'Network error during Google sign-in. Check your connection.';
    }
    if (e.code == 'configuration-not-found' ||
        e.code == 'operation-not-allowed') {
      return 'Google sign-in is not fully configured in Firebase. Enable Google provider and add the Android SHA keys.';
    }
    return e.message ?? 'Firebase could not complete Google sign-in.';
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return Left(ServerFailure("No authenticated user"));
      }

      final uid = currentUser.uid;

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
