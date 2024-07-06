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

  User? get user => firebaseAuth.currentUser;

  Future<String> getWaitingMessage() async {
    QuerySnapshot querySnapshot = await concessionRequestCollection
        .where('status', isEqualTo: ConcessionStatus.unserviced)
        .get();

    int unprocessed = querySnapshot.size;
    // if (unprocessed > 50) {
    //   return getCorrectDate(date.add(Duration(days: 1)));
    // } else {
    //   return date;
    // }
    // return unprocessed;

    return "Your concession request will be serviced after issuing ${unprocessed} previous requests";
  }

  Future<ConcessionDetailsModel?> getConcessionDetails() async {
    try {
      var value = await concessionDetailsCollection.doc(user!.uid).get();
      // debugPrint('concession details are being fetched');
      if (value.exists) {
        var detailsMap = value.data() as Map<String, dynamic>;
        ConcessionDetailsModel concessionDetailsData =
            ConcessionDetailsModel.fromJson(detailsMap);
        if (concessionDetailsData.status == ConcessionStatus.unserviced) {
          // debugPrint(concessionDetailsData.status);
          // int waitingQueue = await getWaitingList();
          concessionDetailsData.statusMessage = await getWaitingMessage();
        } // debugPrint(
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

  Future<ConcessionRequestModel?> getConcessionRequest() async {
    try {
      var value = await concessionRequestCollection.doc(user!.uid).get();
      print('concession requests are being fetched ');
      print(value.data());
      if (value.exists) {
        print("Concession Request Present");
        var detailsMap = value.data() as Map<String, dynamic>;
        ConcessionRequestModel concessionRequestData =
        ConcessionRequestModel.fromJson(detailsMap);

        return concessionRequestData;
      } else {

        // Document does not exist
        return null;
      }
    } catch (error) {

      // Handle any errors that might occur during the Firestore operation
      print("Error fetching concession request: $error");
      return null;
    }
  }

  Future<String> uploadPhoto(File file, String docName) async {
// idCard
// prevpass
// File idCardPhoto,
//       File previousPassPhoto
    var idRef = await firebaseStorage
        .ref()
        .child(docName)
        .child("/${user?.uid}")
        .putFile(file);
    String url = await idRef.ref.getDownloadURL();
    return url;
  }

  Future<ConcessionDetailsModel> applyConcession(
    ConcessionDetailsModel concessionDetails,
  ) async {
    // int waitingQueue = await getWaitingList();
    // String statusMessage =
    //     "Your concession request will be serviced after issuing ${waitingQueue} previous requests";

    String statusMessage = await getWaitingMessage();
    // var idRef = await firebaseStorage
    //     .ref()
    //     .child("idCard")
    //     .child("/${user?.uid}")
    //     .putFile(idCardPhoto);
    // var idCardURL = await idRef.ref.getDownloadURL();

    // var passRef = await firebaseStorage
    //     .ref()
    //     .child("prevpass")
    //     .child("/${user?.uid}")
    //     .putFile(previousPassPhoto);
    // var prevPassURL = await passRef.ref.getDownloadURL();

    // DateTime concessionDate = await getCorrectDate(DateTime.now());
    String status = ConcessionStatus.unserviced;
    // String statusMessage =
    //     "Your pass will be ready on ${DateFormat('dd MMM').format(concessionDate)}";
    ConcessionRequestModel concessionRequest = ConcessionRequestModel(
      uid: user!.uid,
      time: DateTime.now(),
      status: status,
      statusMessage: "",
    );

    // try {
    //   await concessionRequestCollection.add(concessionRequest.toJson());
    //   print('request created successfully!');
    // } catch (e) {
    //   print('Error updating or creating document: $e');
    // }
    try {
      // Add or update the concession request in Firestore
      DocumentReference concessionRequestDoc =
      concessionRequestCollection.doc(user!.uid);
      await concessionRequestDoc.set(concessionRequest.toJson(),
          SetOptions(merge: true)); // Use merge to update or create

      print('Concession request updated or created successfully!');
    } catch (e) {
      print('Error updating or creating concession request: $e');
    }


    // concessionDetails.idCardURL = "";
    concessionDetails.status = status;
    concessionDetails.statusMessage = statusMessage;
    // concessionDetails.previousPassURL = "";

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
