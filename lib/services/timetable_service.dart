import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsec_app/models/timetable_model/timetable_model.dart';

class TimetableService {
  final FirebaseFirestore _firestore;
  TimetableService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _timetable => _firestore.collection('TimeTable');
  Stream get collectionStream => _firestore.collection('TimeTable').snapshots();
  Stream get documentStream =>
      _firestore.collection('TimeTable').doc('C11').snapshots();
      

  void fetchTimetablebyBatchandDay(
      String batch, String Day) {
        
        _firestore.collection('TimeTable').doc('C11').snapshots();
  }


}
