import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/occassion_model/occasion_model.dart';

final occasionServicesProvider = Provider((ref) {
  return OccasionServices(firebaseFirestore: FirebaseFirestore.instance);
});

class OccasionServices {
  final FirebaseFirestore _firebaseFirestore;

  OccasionServices({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Stream<List<OccasionModel>?> getOccasionDetails() {
    List<OccasionModel> occasionsDetails = [];

    final docRef = _firebaseFirestore.collection("Occasions");

    return docRef.snapshots().map((occasion) {
      for (final doc in occasion.docs) {
        occasionsDetails.add(OccasionModel.fromJson(doc.data()));
      }

      return occasionsDetails;
    });
  }
}
