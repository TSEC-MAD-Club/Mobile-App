import 'package:tsec_app/new_ui/screens/attendance_screen/firebase_attendance_totalLects_2025.dart';

class AttendanceChecker {
  void updateLectureCount(
      String action, String actionTemp, String subjectName) {
    try {
      //FIRST TIME CLICKING ON A DATE'S ATTENDANCE, SINCE TEMP IN ""
      if (actionTemp == "") {
        if (action == "Pre") {
          FirebaseAttendanceTotallects2025()
              .updateLectureAttended("Pre", subjectName);

          FirebaseAttendanceTotallects2025()
              .updateTotalLects("Pre", subjectName);
        } else if (action == 'Abs') {
          FirebaseAttendanceTotallects2025()
              .updateLectureAttended("Abs", subjectName);

          FirebaseAttendanceTotallects2025()
              .updateTotalLects("Pre", subjectName);
        }
      } else if (action == 'Pre' && actionTemp != 'Pre') {
        FirebaseAttendanceTotallects2025()
            .updateLectureAttended("Pre", subjectName);
      } else if ((action == 'Abs' || action == 'Can') && actionTemp == 'Pre') {
        FirebaseAttendanceTotallects2025()
            .updateLectureAttended("Abs", subjectName);
      }

      //UPDATING TOTAL LECTURES SUBTRACTING OR ADDING TOTAL LECTURES
      if (action == 'Can' && actionTemp != 'Can') {
        FirebaseAttendanceTotallects2025().updateTotalLects("Can", subjectName);
      } else if (action != 'Can' && actionTemp == 'Can') {
        FirebaseAttendanceTotallects2025().updateTotalLects("Pre", subjectName);
      }
    } catch (e) {
      rethrow;
    }
  }
}
