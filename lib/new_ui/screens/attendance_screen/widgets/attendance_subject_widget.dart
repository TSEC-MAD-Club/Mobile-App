import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';

class AttendanceSubjectWidget extends StatelessWidget {
  final double attendance;
  const AttendanceSubjectWidget({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: timePickerBorder, width: 1.0), // Change the color and width as needed
          borderRadius: BorderRadius.circular(10.0),
          color: timePickerBg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Subject Name',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    '5/10',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '50%',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text("Not accepted", style: TextStyle(color: Colors.white, fontSize: 12),),
              const SizedBox(height: 10,),
              LinearProgressIndicator(
                value: attendance,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ElevatedButton(
                  //   onPressed: (){},
                  //   child: const Text('Present', style: TextStyle(color: Colors.white),),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.green,
                  //     shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  //       ),
                  //   ),
                  // ElevatedButton(
                  //   onPressed: (){},
                  //   child: const Text('Absent', style: TextStyle(color: Colors.white),),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.red,
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  //       ),
                  //   ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
