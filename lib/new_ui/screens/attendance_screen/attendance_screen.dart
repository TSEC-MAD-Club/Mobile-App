import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_subject_widget.dart';

//make this a consumer widget later
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var present =8;
    var totalLec=10;
    //put the attendance from a provider here
    double attendance = present/totalLec;
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // const SizedBox(height: 20,),
            // Text(
            //   attendance < 0.75 ? 'Your attendance is low' : 'Your attendance is good',
            //   style: TextStyle(color: Colors.white, fontSize: 20),
            // ),
            const SizedBox(height: 30,),
            Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '' ,
                          style: TextStyle(color: Colors.white, fontSize: 4),
                                        ),
                        Text(
                          '${attendance * 100}%' ,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                                        ),
                        Text(
                          '${present}/${totalLec}' ,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: attendance,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(oldDateSelectBlue),
                    strokeWidth: 3,
                    strokeAlign: BorderSide.strokeAlignInside,
                    strokeCap: StrokeCap.butt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            //put the subject attendance cards from here
            const SizedBox(height: 10,),
            AttendanceSubjectWidget(attendance: 0.75),
          ],
        ),
      ),
    );
  }
}
