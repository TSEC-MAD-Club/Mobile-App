import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  Timestamp? startDate;
  Timestamp? endDate;
  String? content;
  String? div;
  String? branch;
  String? batch;
  String? docURL;
  String? title;
  String? gradYear;

  AnnouncementModel(
      {this.startDate,
        this.content,
        this.endDate,
        this.div,
        this.branch,
        this.batch,
        this.docURL,
        this.gradYear,
        this.title});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    content = json['content'];
    endDate = json['endDate'];
    div = json['div'];
    branch = json['branch'];
    batch = json['batch'];
    docURL = json['docURL'];
    title = json['title'];
    gradYear = json["gradYear"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['div'] = this.div;
    data['content'] = this.content;
    data['branch'] = this.branch;
    data['batch'] = this.batch;
    data['docURL'] = this.docURL;
    data['title'] = this.title;
    data['gradYear'] = this.gradYear;
    return data;
  }
}