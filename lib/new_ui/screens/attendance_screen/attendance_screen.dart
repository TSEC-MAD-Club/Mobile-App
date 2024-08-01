import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_subject_widget.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendanceservice.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AttendanceService attendanceService = AttendanceService();
  int totalLectures = 0;
  int attendedLectures = 0;

  /*@override
  void initState() {
    super.initState();
    _fetchAndSetAttendance();

  }*/

  Future<void> _fetchAndSetAttendance() async {
    var attendanceData = await fetchAttendanceData();
    setState(() {
      totalLectures = attendanceData['totalLectures']!;
      attendedLectures = attendanceData['attendedLectures']!;
      print("init state");
      print(totalLectures);
      print(attendedLectures);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isEnabled = true;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Attendance")
              .doc(auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var documentSnapshot = snapshot.data as DocumentSnapshot;
            if (documentSnapshot.data() == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/attendance.png',
                      width: 250,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Please add Subject",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            var data = documentSnapshot.data() as Map<String, dynamic>;
            List attendanceList = data['attendance'];
            //List<Map<String, dynamic>> attendanceList2 = attendanceList.cast<Map<String, dynamic>>();
            Map<String, dynamic> circularMap =
                calculateAttendance(attendanceList);

            if (attendanceList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/attendance.png',
                      width: 250,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Please add Subject",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 4),
                                ),
                                Text(
                                  '${((circularMap["attendedLectures"] / circularMap["totalLectures"]) * 100).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                Text(
                                  '${circularMap["attendedLectures"]}/${circularMap["totalLectures"]}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: circularMap["totalLectures"] == 0
                                ? 0
                                : (circularMap["attendedLectures"] /
                                    circularMap["totalLectures"]),
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                oldDateSelectBlue),
                            strokeWidth: 5,
                            strokeAlign: BorderSide.strokeAlignInside,
                            strokeCap: StrokeCap.round,
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
                    ListView.builder(
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
                                TextEditingController subjectNameController =
                                    TextEditingController(
                                        text: attendanceInfo["subject_name"]);
                                TextEditingController totalLecturesController =
                                    TextEditingController(
                                        text:
                                            attendanceInfo["total"].toString());
                                TextEditingController
                                    attendedLecturesController =
                                    TextEditingController(
                                        text: attendanceInfo["present"]
                                            .toString());

                                final _updateformKey = GlobalKey<FormState>();

                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Text('Update Subject'),
                                  content: Form(
                                    key: _updateformKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "Please enter some value";
                                              }
                                            },
                                            controller: subjectNameController,
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              labelText: 'Subject Name',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              errorStyle: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            validator: (val) {
                                              String totalLectures =
                                                  totalLecturesController.text;

                                              if (val == null || val.isEmpty) {
                                                return "Please enter some value";
                                              } else if (totalLectures.isNotEmpty &&
                                                  int.parse(val) > int.parse(totalLectures)) {
                                                return "Please enter correct value";
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            controller:
                                                attendedLecturesController,
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              labelText: 'Attended Lectures',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              errorStyle: TextStyle(fontSize: 12),
                                              focusColor: Colors.red,
                                              fillColor: Colors.transparent,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            validator: (val) {
                                              String attendedLectures =
                                                  attendedLecturesController.text;
                                              if (val == null || val.isEmpty) {
                                                return "Please enter some value";
                                              } else if (attendedLectures.isNotEmpty &&
                                                  int.parse(val) <
                                                      int.parse(attendedLectures)) {
                                                return "Please enter correct value";
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            controller: totalLecturesController,
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Total Lectures Till Now',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              errorStyle: TextStyle(fontSize: 12),
                                              focusColor: Colors.red,
                                              fillColor: Colors.transparent,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {

                                        if (_updateformKey.currentState!.validate()) 
                                        {
                                          String subjectName =
                                              subjectNameController.text;
                                          int totalLectures = int.parse(
                                              totalLecturesController.text);
                                          int attendedLectures = int.parse(
                                              attendedLecturesController.text);

                                          Map<String, dynamic> updatedSubject = {
                                            "subject_name": subjectName,
                                            "total": totalLectures,
                                            "present": attendedLectures
                                          };

                                          await AttendanceService.updateSubject(
                                              attendanceList,
                                              index,
                                              updatedSubject);

                                          Navigator.of(context).pop();
                                        }
                                        

                                        /*DocumentSnapshot doc = await FirebaseFirestore.instance
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

                                            await FirebaseFirestore.instance
                                                .collection("Attendance")
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .update({'attendance': attendanceList});
                                          }
                                        }*/

                                        
                                      },
                                      child: Text('Update',
                                          style: TextStyle(color: Colors.blue)),
                                    ),
                                    TextButton(
                                      onPressed: () async {

                                        await AttendanceService.deleteSubject(
                                            attendanceList, index);

                                        /*DocumentSnapshot doc = await FirebaseFirestore.instance
                                            .collection("Attendance")
                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                            .get();

                                        if (doc.exists) {
                                          var data = doc.data() as Map<String, dynamic>;
                                          List attendanceList = data['attendance'];

                                          attendanceList.removeWhere((item) => item['subject_name'] == attendanceInfo['subject_name']);


                                          await FirebaseFirestore.instance
                                              .collection("Attendance")
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .update({'attendance': attendanceList});
                                        }
                                        _fetchAndSetAttendance();*/
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: timePickerBorder, width: 1.0),
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
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${attendanceInfo['present']}/${attendanceInfo['total']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          '${(attendanceInfo['present'] / attendanceInfo['total'] * 100).toInt()}%',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    LinearProgressIndicator(
                                      value: attendanceInfo['present'] /
                                          attendanceInfo['total'],
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              oldDateSelectBlue),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await AttendanceService.markPresent(
                                                attendanceList, index);
                                            /*_fetchAndSetAttendance();*/
                                          },
                                          child: const Text(
                                            'Present',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                commonbgL3ightblack,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await AttendanceService.markAbsent(
                                                attendanceList, index);
                                            /*_fetchAndSetAttendance();*/
                                          },
                                          child: const Text(
                                            'Absent',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                commonbgL3ightblack,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        width: size.width * 0.88,
                                        alignment: Alignment.center,
                                        // decoration: BoxDecoration(
                                        //   border: Border.all(color: timePickerBorder, width: 1.0),
                                        //   borderRadius: BorderRadius.circular(10.0),
                                        //   color: timePickerBg,
                                        // ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getTextForCard(
                                                attendanceInfo['present'],
                                                attendanceInfo['total']),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController subjectNameController =
                  TextEditingController();
              TextEditingController totalLecturesController =
                  TextEditingController();
              TextEditingController attendedLecturesController =
                  TextEditingController();

              final _formKey = GlobalKey<FormState>();

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Increased corner radius
                ),
                title: Text(
                  'Add Subject',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                content: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter some value";
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            // Set text color to white
                            controller: subjectNameController,
                            decoration: InputDecoration(
                              focusColor: Colors.red,
                              labelText: 'Subject Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              errorStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (val) {
                              String totalLectures =
                                  totalLecturesController.text;

                              if (val == null || val.isEmpty) {
                                return "Please enter some value";
                              } else if (totalLectures.isNotEmpty &&
                                  int.parse(val) > int.parse(totalLectures)) {
                                return "Please enter correct value";
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            // Set text color to white
                            controller: attendedLecturesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: 'Attended Lectures',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              errorStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (val) {
                              int attendedLectures =
                                  int.parse(attendedLecturesController.text) ?? 0;
                              if (val == null || val.isEmpty) {
                                return "Please enter some value";
                              } else if (attendedLectures !=0 &&
                                  int.parse(val) <
                                      attendedLectures) {
                                return "Please enter correct value";
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            // Set text color to white
                            controller: totalLecturesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: 'Total Lectures Till Now',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              errorStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String subjectName = subjectNameController.text;
                        int totalLectures =
                            int.parse(totalLecturesController.text);
                        int attendedLectures =
                            int.parse(attendedLecturesController.text);

                        Map<String, dynamic> updatedSubject = {
                          "subject_name": subjectName,
                          "total": totalLectures,
                          "present": attendedLectures
                        };
                        await AttendanceService.addSubject(updatedSubject);
                        /*FirebaseFirestore.instance
                            .collection("Attendance")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'attendance': FieldValue.arrayUnion([{
                            'subject_name': subjectName,
                            'total': totalLectures,
                            'present': attendedLectures
                          }])
                        }, SetOptions(merge: true));
                        _fetchAndSetAttendance();*/
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              );
            },
          );
        },
        shape: CircleBorder(
          side: BorderSide(
              color: commonbgL4ightblack,
              width: 0.5), // Customize the border color and width
        ),
        backgroundColor: commonbgLightblack,
        child: Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}

Future<Map<String, int>> fetchAttendanceData() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection("Attendance")
      .doc(auth.currentUser!.uid)
      .get();

  if (documentSnapshot.exists) {
    var data = documentSnapshot.data() as Map<String, dynamic>;
    List attendanceList = data['attendance'];
    List<Map<String, dynamic>> attendanceList2 =
        attendanceList.cast<Map<String, dynamic>>();

    return calculateAttendance(attendanceList2);
  } else {
    return {'totalLectures': 0, 'attendedLectures': 0};
  }
}

Map<String, int> calculateAttendance(List attendanceList) {
  int totalLectures = 0;
  int attendedLectures = 0;

  for (var attendanceInfo in attendanceList) {
    totalLectures += (attendanceInfo['total'] as num?)?.toInt() ?? 0;
    attendedLectures += (attendanceInfo['present'] as num?)?.toInt() ?? 0;
  }

  return {
    'totalLectures': totalLectures,
    'attendedLectures': attendedLectures,
  };
}

String getTextForCard(int at, int tt) {
  double attended = at.toDouble();
  double total = tt.toDouble();
  int toAttend = 0;

  if (attended / total == 0.75) {
    return "You are Just on track, keep it up !";
  } else if (attended / total > 0.75) {
    while (1 == 1) {
      double t = (attended) / (total + 1);
      if (t >= 0.75) {
        total++;
        toAttend--;
      } else {
        break;
      }
    }
  } else {
    while (1 == 1) {
      double t = (attended + 1) / (total + 1);
      if (t <= 0.75) {
        total++;
        attended++;
        toAttend++;
      } else {
        break;
      }
    }
  }

  if (toAttend <= 0) {
    return "You are on track, keep it up !";
  }

  return "Your presence in next ${toAttend} classes is crucial";
}
