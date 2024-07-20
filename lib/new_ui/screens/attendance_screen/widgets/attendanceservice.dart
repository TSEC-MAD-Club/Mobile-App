import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceService{

  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference firestore = FirebaseFirestore.instance.collection("Attendance");

  static markPresent(List attendanceList,int index)async{
    attendanceList[index]['present']++;
    attendanceList[index]['total']++;
    await firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

  static markAbsent(List attendanceList,int index)async{
    attendanceList[index]['total']++;
    await firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

  static updateSubject(List attendanceList,int index,Map<String,dynamic> updatedSubject)async{
    attendanceList[index] = updatedSubject;
    await firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

  static deleteSubject(List attendanceList,int index)async{
    attendanceList.removeAt(index);
    await firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

  static addSubject(Map<String,dynamic> updatedSubject)async{
    final get = await firestore.doc(auth.currentUser!.uid).get();
    final data = get.data() as Map<String,dynamic>;
    List attendanceList = data['attendance'];
    attendanceList.add(updatedSubject);
    await firestore.doc(auth.currentUser!.uid).set({"attendance":attendanceList});
  }

}