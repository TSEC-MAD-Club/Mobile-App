import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_subject_widget.dart';

//make this a consumer widget later
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //put the attendance from a provider here
    double attendance = 0.5;
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Text(
              attendance < 0.75 ? 'Your attendance is low' : 'Your attendance is good',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30,),
            Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${attendance * 100} %' ,
                      style: TextStyle(color: Colors.white, fontSize: 50),
                                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                  child: CircularProgressIndicator(
                    value: attendance,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 20,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Present: 5", style: TextStyle(color: Colors.white),),
                Text("Absent: 5", style: TextStyle(color: Colors.white),),
              ],
            ),
            const SizedBox(height: 20,),
            //put the subject attendance cards from here
            AttendanceSubjectWidget(attendance: 0.5),
            const SizedBox(height: 10,),
            AttendanceSubjectWidget(attendance: 0.75),
          ],
        ),
      ),
    );
  }
}
