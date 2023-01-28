import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';

final authServiceProvider = Provider((ref) {
  return AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

class AuthService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AuthService(this.firebaseAuth, this.firebaseFirestore);

  Stream<User?> get userCurrentState => firebaseAuth.authStateChanges();

  Future<UserCredential?> signInUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      } else
        showSnackBar(context, e.message.toString());
      return null;
    }
  }

  void updatePassword(String password, BuildContext context) {
    userCurrentState.listen((user) async {
      try {
        await user?.updatePassword(password);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    });
  }

  Future<StudentModel?> fetchStudentDetails(
      String email, BuildContext context) async {
    StudentModel? studentModel;

    try {
      final studentSnap = await firebaseFirestore
          .collection("Students ")
          .where("email", isEqualTo: email)
          .get();

      final studentDoc = studentSnap.docs.map((e) {
        return e.data();
      });

      for (final element in studentDoc) {
        studentModel = StudentModel.fromJson(element);
      }
      log(studentModel!.toString());
    } on FirebaseException catch (e) {
      showSnackBar(
          context, e.stackTrace.toString() + " " + e.message.toString());
    }

    return studentModel;
  }
}
