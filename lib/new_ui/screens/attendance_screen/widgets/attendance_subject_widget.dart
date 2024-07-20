import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';

class AttendanceSubjectWidget extends StatelessWidget {
  final double attendance;
  const AttendanceSubjectWidget({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5/10',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    '50%',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
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
                  ElevatedButton(
                    onPressed: (){},
                    child: const Text('Present', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: commonbgL3ightblack,
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                    ),
                  ElevatedButton(
                    onPressed: (){},
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // Flip horizontally
                      child: Icon(Icons.refresh_outlined, color: Colors.white),
                    )
                    ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: commonbgL3ightblack,
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                    ),
                  ElevatedButton(
                    onPressed: (){},
                    child: const Text('Absent', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: commonbgL3ightblack,
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                    ),

                ],
              ),
              const SizedBox(height: 10,),
              Center(
                child: Container(
                  height: 1,
                  width: size.width*0.88,
                  color: commonbgL4ightblack,
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      )
    );
  }
}
