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
  CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('Students ');

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

  void updatePassword(String password, BuildContext context) async {
    User user = firebaseAuth.currentUser!;
    await user.updatePassword(password);
  }

  Future<StudentModel> updateUserDetails(StudentModel student) async {
    DocumentReference studentDoc = studentCollection.doc(user!.uid);
    await studentDoc.update(student.toJson());
    final updatedUserData = await studentDoc.get();

    var userMap = updatedUserData.data() as Map<String, dynamic>;
    StudentModel updatedStudentData = StudentModel.fromJson(userMap);
    debugPrint("student data is $updatedStudentData");
    return updatedStudentData;
  }

  Future<StudentModel?> fetchStudentDetails(
      User? user, BuildContext context) async {
    StudentModel? studentModel;

    try {
      final studentSnap =
          await firebaseFirestore.collection("Students ").doc(user!.uid).get();

      final studentDoc = studentSnap.data();
      if (studentDoc != null) {
        studentModel = StudentModel.fromJson(studentDoc);
      } else {
        studentModel = null;
      }
    } on FirebaseException catch (e) {
      showSnackBar(
          context, e.stackTrace.toString() + " " + e.message.toString());
    }

    return studentModel;
  }

  void signout() async {
    await firebaseAuth.signOut();
  }
}
