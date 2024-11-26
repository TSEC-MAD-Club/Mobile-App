import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendanceservice.dart';

class AddAttendanceScreen extends StatefulWidget {

  int? index;
  final bool isUpdate;
  Map<String, dynamic>? updatedSubject;
  List<dynamic>? attendanceList;
  AddAttendanceScreen({required this.isUpdate, this.updatedSubject,this.index,this.attendanceList});

  @override
  State<AddAttendanceScreen> createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {

  late TextEditingController subjectController;
  late TextEditingController totalLecturesController;
  late TextEditingController attendedLecturesController;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController(text: widget.isUpdate ? widget.updatedSubject!['subject_name']:"");
    totalLecturesController = TextEditingController(text: widget.isUpdate ? widget.updatedSubject!['total'].toString():"");
    attendedLecturesController = TextEditingController(text: widget.isUpdate ? widget.updatedSubject!['present'].toString():"");
  }

  TextStyle inputTextFieldStyle = TextStyle(color: Colors.white,);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          if (widget.isUpdate) IconButton(onPressed: (){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("Are you sure you want to delete?",),
                actions: [
                  InkWell(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: size.width*0.3,
                      decoration: BoxDecoration(
                        color: commonbgL4ightblack,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text("Cancel",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      await AttendanceService.deleteSubject(widget.attendanceList!, widget.index!);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: size.width*0.3,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text("Delete",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              );
            });
          }, icon: Icon(Icons.delete,color: Colors.red,),) else SizedBox(),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Add a Subject",style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
          ),

          SizedBox(
            height: size.height*0.04,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Subject Name: ",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
          ),

          SizedBox(
            height: size.height*0.01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: commonbgL4ightblack,
              borderRadius: BorderRadius.circular(5)
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: inputTextFieldStyle,
              controller: subjectController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),


          SizedBox(
            height: size.height*0.04,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Attended Lectures: ",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
          ),

          SizedBox(
            height: size.height*0.01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: commonbgL4ightblack,
                borderRadius: BorderRadius.circular(5)
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: inputTextFieldStyle,
              keyboardType: TextInputType.number,
              controller: attendedLecturesController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),


          SizedBox(
            height: size.height*0.04,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Total Lectures: ",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
          ),

          SizedBox(
            height: size.height*0.01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: commonbgL4ightblack,
                borderRadius: BorderRadius.circular(5)
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: inputTextFieldStyle,
              keyboardType: TextInputType.number,
              controller: totalLecturesController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),

          SizedBox(
            height: size.height*0.325,
          ),

          InkWell(
            onTap: () async{
              bool isSubjectAdded = await addSubject();
              if(isSubjectAdded){
                Navigator.pop(context);
                showSnackBarMessage("Subject Added Successfully", Colors.green);
              }
            },
            splashFactory: NoSplash.splashFactory,
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: cardcolorblue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("Send Mail",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> addSubject() async{
    if(totalLecturesController.text.isEmpty || attendedLecturesController.text.isEmpty || subjectController.text.isEmpty){
      showSnackBarMessage("Fields cannot be left blank", Colors.red);
      return false;
    }
    else if(totalLecturesController.text.contains(',') || totalLecturesController.text.contains('.') || attendedLecturesController.text.contains(',') || attendedLecturesController.text.contains('.')){
      showSnackBarMessage("Attended and Total Lectures can only have Numeric Charachters", Colors.red);
      return false;
    }
    String subjectName = subjectController.text;
    int totalLectures =
    int.parse(totalLecturesController.text);
    int attendedLectures =
    int.parse(attendedLecturesController.text);

    if(totalLectures.isNegative || attendedLectures.isNegative){
      showSnackBarMessage("Lectures cannot be Negative", Colors.red);
      return false;
    }else if(attendedLectures>totalLectures){
      showSnackBarMessage("Attended Lectures cannot be greater than Total Lectures", Colors.red);
      return false;
    }
    else{
      Map<String, dynamic> updatedSubject = {
        "subject_name": subjectName,
        "total": totalLectures,
        "present": attendedLectures
      };
      if(widget.isUpdate){
        await AttendanceService.updateSubject(widget.attendanceList!, widget.index!, updatedSubject);
      }else {
        await AttendanceService.addSubject(updatedSubject);
      }
      return true;
    }

  }

  showSnackBarMessage(String text,Color color){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text,style: TextStyle(color: Colors.white),),backgroundColor: color,),);
  }
}
