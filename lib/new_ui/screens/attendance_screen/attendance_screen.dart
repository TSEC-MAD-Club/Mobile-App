import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_subject_widget.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendanceservice.dart';
import 'package:tsec_app/provider/auth_provider.dart';

//make this a consumer widget later
class AttendanceScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AttendanceService attendanceService = AttendanceService();

  @override
  Widget build(BuildContext context) {
    var present = 8;
    var totalLec = 10;
    //put the attendance from a provider here
    double attendance = present / totalLec;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // const SizedBox(height: 20,),
              // Text(
              //   attendance < 0.75 ? 'Your attendance is low' : 'Your attendance is good',
              //   style: TextStyle(color: Colors.white, fontSize: 20),
              // ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '',
                            style: TextStyle(color: Colors.white, fontSize: 4),
                          ),
                          Text(
                            '${attendance * 100}%',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          Text(
                            '${present}/${totalLec}',
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
                      valueColor:
                      AlwaysStoppedAnimation<Color>(oldDateSelectBlue),
                      strokeWidth: 3,
                      strokeAlign: BorderSide.strokeAlignInside,
                      strokeCap: StrokeCap.butt,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //put the subject attendance cards from here
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Attendance")
                      .doc(auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var documentSnapshot = snapshot.data as DocumentSnapshot;
                    // print("lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
                    if(documentSnapshot.data()==null){
                      return Center(child: Text("Please add Subject",style: TextStyle(color: Colors.white),));
                    }
                    var data = documentSnapshot.data() as Map<String, dynamic>;
                    List attendanceList = data['attendance'];
                    // return ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: attendanceList.length,
                    //   itemBuilder: (context, index) {
                    //     var attendanceInfo = attendanceList[index];
                    //     return Card(
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             border: Border.all(color: timePickerBorder, width: 1.0), // Change the color and width as needed
                    //             borderRadius: BorderRadius.circular(10.0),
                    //             color: timePickerBg,
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Row(
                    //                   //crossAxisAlignment: CrossAxisAlignment.end,
                    //                   children: [
                    //                     Text(
                    //                       attendanceInfo["subject_name"],
                    //                       style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    //                     ),
                    //                     SizedBox(width: 5,),
                    //                   ],
                    //                 ),
                    //                 const SizedBox(height: 10,),
                    //                 Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Text(
                    //                       '${attendanceInfo['present']}/${attendanceInfo['total']}',
                    //                       style: TextStyle(color: Colors.white, fontSize: 14),
                    //                     ),
                    //                     Text(
                    //                       '${(attendanceInfo['present']/attendanceInfo['total'] *100).toInt()}%',
                    //                       style: TextStyle(color: Colors.white, fontSize: 14),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 const SizedBox(height: 10,),
                    //                 LinearProgressIndicator(
                    //                   value: attendanceInfo['present']/attendanceInfo['total'],
                    //                   backgroundColor: Colors.white,
                    //                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    //                 ),
                    //                 const SizedBox(height: 15,),
                    //                 Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     ElevatedButton(
                    //                       onPressed: (){
                    //                         AttendanceService.markPresent(attendanceList, index);
                    //                       },
                    //                       child: const Text('Present', style: TextStyle(color: Colors.white),),
                    //                       style: ElevatedButton.styleFrom(
                    //                         backgroundColor: commonbgL3ightblack,
                    //                         shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    //                       ),
                    //                     ),
                    //                     ElevatedButton(
                    //                       onPressed: (){},
                    //                       child: Transform(
                    //                         alignment: Alignment.center,
                    //                         transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // Flip horizontally
                    //                         child: Icon(Icons.refresh_outlined, color: Colors.white),
                    //                       )
                    //                       ,
                    //                       style: ElevatedButton.styleFrom(
                    //                         backgroundColor: commonbgL3ightblack,
                    //                         shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    //                       ),
                    //                     ),
                    //                     ElevatedButton(
                    //                       onPressed: (){
                    //                         AttendanceService.markAbsent(attendanceList, index);
                    //                       },
                    //                       child: const Text('Absent', style: TextStyle(color: Colors.white),),
                    //                       style: ElevatedButton.styleFrom(
                    //                         backgroundColor: commonbgL3ightblack,
                    //                         shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    //                       ),
                    //                     ),
                    //
                    //                   ],
                    //                 ),
                    //                 const SizedBox(height: 10,),
                    //                 Center(
                    //                   child: Container(
                    //                     height: 1,
                    //                     width: size.width*0.88,
                    //                     color: commonbgL4ightblack,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 10,),
                    //               ],
                    //             ),
                    //           ),
                    //         )
                    //     );
                    //   },
                    // );
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        var attendanceInfo = attendanceList[index];

                        return GestureDetector(
                          onTap: () {
                            // Show dialog with current values for modification
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController subjectNameController = TextEditingController(text: attendanceInfo["subject_name"]);
                                TextEditingController totalLecturesController = TextEditingController(text: attendanceInfo["total"].toString());
                                TextEditingController attendedLecturesController = TextEditingController(text: attendanceInfo["present"].toString());

                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Text('Update Subject'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: subjectNameController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: 'Subject Name',
                                            labelStyle: TextStyle(color: Colors.white70),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: attendedLecturesController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: 'Attended Lectures',
                                            labelStyle: TextStyle(color: Colors.white70),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: totalLecturesController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: 'Total Lectures Till Now',
                                            labelStyle: TextStyle(color: Colors.white70),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),

                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        String subjectName = subjectNameController.text;
                                        int totalLectures = int.parse(totalLecturesController.text);
                                        int attendedLectures = int.parse(attendedLecturesController.text);

                                        // Fetch the document to get the current data
                                        DocumentSnapshot doc = await FirebaseFirestore.instance
                                            .collection("Attendance")
                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                            .get();

                                        if (doc.exists) {
                                          var data = doc.data() as Map<String, dynamic>;
                                          List attendanceList = data['attendance'];

                                          // Find the index of the subject to update
                                          int indexToUpdate = attendanceList.indexWhere((item) => item['subject_name'] == attendanceInfo['subject_name']);

                                          if (indexToUpdate != -1) {
                                            // Update the specific item
                                            attendanceList[indexToUpdate] = {
                                              'subject_name': subjectName,
                                              'total': totalLectures,
                                              'present': attendedLectures,
                                            };

                                            // Update the document with the modified array
                                            await FirebaseFirestore.instance
                                                .collection("Attendance")
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .update({'attendance': attendanceList});
                                          }
                                        }

                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Update', style: TextStyle(color: Colors.blue)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Fetch the document to get the current data
                                        DocumentSnapshot doc = await FirebaseFirestore.instance
                                            .collection("Attendance")
                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                            .get();

                                        if (doc.exists) {
                                          var data = doc.data() as Map<String, dynamic>;
                                          List attendanceList = data['attendance'];

                                          // Remove the subject to delete
                                          attendanceList.removeWhere((item) => item['subject_name'] == attendanceInfo['subject_name']);

                                          // Update the document with the modified array
                                          await FirebaseFirestore.instance
                                              .collection("Attendance")
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .update({'attendance': attendanceList});
                                        }

                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                                    ),

                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: timePickerBorder, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                                color: timePickerBg,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          attendanceInfo["subject_name"],
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
                                          '${attendanceInfo['present']}/${attendanceInfo['total']}',
                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                        Text(
                                          '${(attendanceInfo['present']/attendanceInfo['total'] *100).toInt()}%',
                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    LinearProgressIndicator(
                                      value: attendanceInfo['present']/attendanceInfo['total'],
                                      backgroundColor: Colors.white,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ),
                                    const SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            AttendanceService.markPresent(attendanceList, index);
                                          },
                                          child: const Text('Present', style: TextStyle(color: Colors.white),),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: commonbgL3ightblack,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // Flip horizontally
                                            child: Icon(Icons.refresh_outlined, color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: commonbgL3ightblack,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            AttendanceService.markAbsent(attendanceList, index);
                                          },
                                          child: const Text('Absent', style: TextStyle(color: Colors.white),),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: commonbgL3ightblack,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Center(
                                      child: Container(
                                        height: 1,
                                        width: size.width * 0.88,
                                        color: commonbgL4ightblack,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController subjectNameController = TextEditingController();
              TextEditingController totalLecturesController = TextEditingController();
              TextEditingController attendedLecturesController = TextEditingController();

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Increased corner radius
                ),
                title: Text(
                  'Add Subject',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          style: TextStyle(color: Colors.white), // Set text color to white
                          controller: subjectNameController,
                          decoration: InputDecoration(
                            focusColor: Colors.red,
                            labelText: 'Subject Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.white), // Set text color to white
                          controller: attendedLecturesController,
                          decoration: InputDecoration(
                            labelText: 'Attended Lectures',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.white), // Set text color to white
                          controller: totalLecturesController,
                          decoration: InputDecoration(
                            labelText: 'Total Lectures Till Now',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      String subjectName = subjectNameController.text;
                      int totalLectures = int.parse(totalLecturesController.text);
                      int attendedLectures = int.parse(attendedLecturesController.text);

                      // Define your action here to handle the input data
                      FirebaseFirestore.instance
                          .collection("Attendance")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'attendance': FieldValue.arrayUnion([{
                          'subject_name': subjectName,
                          'total': totalLectures,
                          'present': attendedLectures
                        }])
                      }, SetOptions(merge: true));

                      Navigator.of(context).pop();
                    },
                    child: Text('Add', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              );
            },
          );
        },
        shape: CircleBorder(
          side: BorderSide(color: commonbgL4ightblack, width: 0.5), // Customize the border color and width
        ),
        backgroundColor: commonbgLightblack,
        child: Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
