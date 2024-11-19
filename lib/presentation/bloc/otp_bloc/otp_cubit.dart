import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  FirebaseAuth auth = FirebaseAuth.instance;
  late String verificationId;
  void codeSent(String verificationId, int? resendToken) {
    if (kDebugMode) {
      print("code sent");
    }
    this.verificationId = verificationId;
    emit(OtpSuccessState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    if (kDebugMode) {
      print("code Auto Retrieval Timeout");
    }
  }

  Future<void> submitPhoneNumber({required String phoneNumber}) async {
    emit(OtpLoadingState());
    if (kDebugMode) {
      print("submitPhoneNumber");
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+249$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        }

        // Handle other errors
      },
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(OtpVerifiedState());
    } catch (e) {
      emit(OtpErrorState(e.toString()));
    }
  }

  Future<void> submitOtp(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
    await signIn(credential);
  }
}
