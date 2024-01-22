import 'package:tsec_app/models/faculty_model/faculty_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';

class UserModel {
  bool isStudent;
  StudentModel? studentModel;
  FacultyModel? facultyModel;

  UserModel({this.isStudent = true, this.studentModel, this.facultyModel});
}
