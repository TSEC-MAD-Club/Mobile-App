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

  User? get user => firebaseAuth.currentUser;

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
      User? user, BuildContext context) async {
    StudentModel? studentModel;

    try {
      final studentSnap =
          await firebaseFirestore.collection("Students ").doc(user!.uid).get();

      final studentDoc = studentSnap.data(); 
      studentModel = StudentModel.fromJson(studentDoc!);
      
    } on FirebaseException catch (e) {
      showSnackBar(
          context, e.stackTrace.toString() + " " + e.message.toString());
    }

    return studentModel;
  }
}
