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
}
