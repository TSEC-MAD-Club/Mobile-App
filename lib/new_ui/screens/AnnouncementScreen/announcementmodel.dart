import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  Timestamp? startDate;
  Timestamp? endDate;
  String? div;
  String? branch;
  String? batch;
  String? docURL;
  String? title;

  AnnouncementModel(
      {this.startDate,
        this.endDate,
        this.div,
        this.branch,
        this.batch,
        this.docURL,
        this.title});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    div = json['div'];
    branch = json['branch'];
    batch = json['batch'];
    docURL = json['docURL'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['div'] = this.div;
    data['branch'] = this.branch;
    data['batch'] = this.batch;
    data['docURL'] = this.docURL;
    data['title'] = this.title;
    return data;
  }
}