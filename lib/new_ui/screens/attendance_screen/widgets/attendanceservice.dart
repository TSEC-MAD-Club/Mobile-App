import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceService{

  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference firestore = FirebaseFirestore.instance.collection("Attendance");

  static markPresent(List attendanceList,int index){
    attendanceList[index]['present']++;
    attendanceList[index]['total']++;
    print(attendanceList[index]['present']);
    firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

  static markAbsent(List attendanceList,int index){
    attendanceList[index]['total']++;
    print(attendanceList[index]['total']);
    firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

}