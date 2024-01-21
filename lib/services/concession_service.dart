import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/models/concession_request_model/concession_request_model.dart';
import 'package:tsec_app/utils/railway_enum.dart';
// import 'package:tsec_app/utils/custom_snackbar.dart';

final concessionServiceProvider = Provider((ref) {
  return ConcessionService(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

class ConcessionService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  ConcessionService(
      this.firebaseAuth, this.firebaseFirestore, this.firebaseStorage);
  CollectionReference concessionDetailsCollection =
      FirebaseFirestore.instance.collection('ConcessionDetails');
  CollectionReference concessionRequestCollection =
      FirebaseFirestore.instance.collection('ConcessionRequest');

  Stream<User?> get userCurrentState => firebaseAuth.authStateChanges();

  User? get user => firebaseAuth.currentUser;

  Future<DateTime> getCorrectDate(DateTime date) async {
    QuerySnapshot querySnapshot = await concessionRequestCollection
        .where('time', isLessThanOrEqualTo: date)
        .where('status', isEqualTo: ConcessionStatus.unserviced)
        .get();

    int unprocessed = querySnapshot.size;
    if (unprocessed > 50) {
      return getCorrectDate(date.add(Duration(days: 1)));
    } else {
      return date;
    }
  }

  Future<ConcessionDetailsModel?> getConcessionDetails() async {
    try {
      var value = await concessionDetailsCollection.doc(user!.uid).get();
      // debugPrint('concession details are being fetched');
      if (value.exists) {
        var detailsMap = value.data() as Map<String, dynamic>;
        ConcessionDetailsModel concessionDetailsData =
            ConcessionDetailsModel.fromJson(detailsMap);

        // debugPrint(
        //     'concession details fetched are: ${concessionDetailsData.toString()}');
        return concessionDetailsData;
      } else {
        // Document does not exist
        return null;
      }
    } catch (error) {
      // Handle any errors that might occur during the Firestore operation
      print("Error fetching concession details: $error");
      return null;
    }
  }

  Future<ConcessionDetailsModel> applyConcession(
      ConcessionDetailsModel concessionDetails,
      File idCardPhoto,
      File previousPassPhoto) async {
    var idRef = await firebaseStorage
        .ref()
        .child("idCard")
        .child("/${user?.uid}")
        .putFile(idCardPhoto);
    var idCardURL = await idRef.ref.getDownloadURL();

    var passRef = await firebaseStorage
        .ref()
        .child("prevpass")
        .child("/${user?.uid}")
        .putFile(previousPassPhoto);
    var prevPassURL = await passRef.ref.getDownloadURL();

    DateTime concessionDate = await getCorrectDate(DateTime.now());
    String status = ConcessionStatus.unserviced;
    String statusMessage =
        "Your pass will be ready on ${DateFormat('dd MMM').format(concessionDate)}";
    ConcessionRequestModel concessionRequest = ConcessionRequestModel(
      uid: user!.uid,
      time: Timestamp.fromDate(concessionDate),
      status: status,
      statusMessage: statusMessage,
    );

    try {
      await concessionRequestCollection.add(concessionRequest.toJson());
      print('request created successfully!');
    } catch (e) {
      print('Error updating or creating document: $e');
    }

    concessionDetails.idCardURL = idCardURL;
    concessionDetails.status = status;
    concessionDetails.statusMessage = statusMessage;
    concessionDetails.previousPassURL = prevPassURL;

    DocumentReference concessionDetailsDoc =
        concessionDetailsCollection.doc(user!.uid);

    try {
      // Try to update the existing document
      await concessionDetailsDoc.update(concessionDetails.toJson());
      print('Document updated successfully!');
    } catch (e) {
      // If the document doesn't exist, create a new one
      if (e is FirebaseException && e.code == 'not-found') {
        await concessionDetailsDoc.set(concessionDetails.toJson());
        print('Document created successfully!');
      } else {
        // Handle other errors
        print('Error updating or creating document: $e');
      }
    }

    final updatedDetailsData = await concessionDetailsDoc.get();
    var detailsMap = updatedDetailsData.data() as Map<String, dynamic>;
    ConcessionDetailsModel updatedConcessionData =
        ConcessionDetailsModel.fromJson(detailsMap);
    return updatedConcessionData;
  }

  // Future<UserCredential?> signInUser(
  //     String email, String password, BuildContext context) async {
  //   try {
  //     UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     return user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       showSnackBar(context, 'No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       showSnackBar(context, 'Wrong password provided for that user.');
  //     } else
  //       showSnackBar(context, e.message.toString());
  //     return null;
  //   }
  // }

  // Future resetPassword(String email, BuildContext context) async {
  //   // User user = firebaseAuth.currentUser!;
  //   // await user.updatePassword(password);

  //   await firebaseAuth.sendPasswordResetEmail(email: email);
  // }

  // void updatePassword(String password, BuildContext context) async {
  //   User user = firebaseAuth.currentUser!;
  //   await user.updatePassword(password);
  // }

  // Future<StudentModel> updateUserDetails(StudentModel student) async {
  //   // DocumentReference studentDoc = studentCollection.doc(user!.uid);
  //   // await studentDoc.update(student.toJson());
  //   // final updatedUserData = await studentDoc.get();

  //   // var userMap = updatedUserData.data() as Map<String, dynamic>;
  //   // StudentModel updatedStudentData = StudentModel.fromJson(userMap);
  //   debugPrint("updated student data in auth service is $updatedStudentData");
  //   return updatedStudentData;
  // }

  // String generateRandomString(int len) {
  //   var r = Random();
  //   return String.fromCharCodes(
  //       List.generate(len, (index) => r.nextInt(33) + 89));
  // }

  // Future<String> updateProfilePic(Uint8List image) async {
  //   // File file = await File.fromRawPath(image).writeAsBytes(image);
  //   Uint8List imageInUnit8List = image;
  //   final tempDir = await getTemporaryDirectory();
  //   File file = await File('${tempDir.path}/image.png').create();
  //   file.writeAsBytesSync(imageInUnit8List);
  //   debugPrint(user!.uid.toString());
  //   var imageRef = await firebaseStorage
  //       .ref()
  //       .child("Images")
  //       .child("/${user?.uid}")
  //       .putFile(file);
  //   var downloadURL = await imageRef.ref.getDownloadURL();
  //   debugPrint("download url in service is $downloadURL");
  //   // https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/Images%2F82K8zTy8bhaW8auWxn2oK3ql6n03?alt=media&token=cdd8d8f3-dd4f-43b0-979a-a2949d5266f6
  //   return downloadURL;
  // }

  // Future<StudentModel?> fetchStudentDetails(
  //     User? user, BuildContext context) async {
  //   StudentModel? studentModel;

  //   try {
  //     final studentSnap =
  //         await firebaseFirestore.collection("Students ").doc(user!.uid).get();

  //     final studentDoc = studentSnap.data();
  //     if (studentDoc != null) {
  //       studentModel = StudentModel.fromJson(studentDoc);
  //     } else {
  //       studentModel = null;
  //     }
  //   } on FirebaseException catch (e) {
  //     showSnackBar(
  //         context, e.stackTrace.toString() + " " + e.message.toString());
  //   }

  //   return studentModel;
  // }

  // Future signout() async {
  //   await firebaseAuth.signOut();
  // }
}
