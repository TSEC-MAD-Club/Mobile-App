class Bugreport {
  final String title;
  final String description;
  final List<String?> attachments;
  bool isResolved;
  DateTime reportTime;
  String userUid;
  Bugreport({required this.title, required this.description, required this.attachments, required this.isResolved, required this.reportTime, required this.userUid});

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'description': description,
      'attachments': attachments,
      'isResolved': isResolved,
      'reportTime': reportTime.toIso8601String(),
      'userUid': userUid,
    };
  }

  factory Bugreport.fromjson(Map<String, dynamic> json){
    return Bugreport(
        title: json['title'],
        description: json['description'],
        attachments: List<String?>.from(json['attachments']),
        isResolved: json['isResolved'],
        reportTime: DateTime.parse(json['reportTime']),
        userUid: json['userUid'],
    );
  }
}