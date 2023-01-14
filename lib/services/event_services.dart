import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/event_model/event_model.dart';

final eventServicesProvider = Provider((ref) {
  return EventServices(firebaseFirestore: FirebaseFirestore.instance);
});

class EventServices {
  final FirebaseFirestore _firebaseFirestore;

  EventServices({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Stream<List<EventModel>?> getEventDetails() {
    List<EventModel> eventsDetails = [];

    final docRef = _firebaseFirestore.collection("Events");

    return docRef.snapshots().map((event) {
      for (var doc in event.docs) {
        eventsDetails.add(EventModel.fromJson(doc.data()));
      }

      return eventsDetails;
    });
  }
}
