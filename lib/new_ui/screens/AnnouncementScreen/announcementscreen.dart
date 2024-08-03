import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../models/announcement_model/announcement_model.dart';
import '../../../models/user_model/user_model.dart';
import 'announcementmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class AnnouncementScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends ConsumerState<AnnouncementScreen> {
  final DateTime _lastDate = DateTime.now();

  late StudentModel? studentModel;

  @override
  void initState() {
    super.initState();
    final UserModel? data = ref.read(userModelProvider);
    studentModel = data?.studentModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20),
        title: Text("Announcements"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('ImportantNotice').doc('Content').snapshots(),
        builder: (context, snapshot) {
          // Loading Announcements
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Has Error in fetching
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // No Announcement in collection
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'No Announcement Available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final List<dynamic> announcementsData = data?['content'] ?? [];

          // Filter announcements based on conditions
          final announcements = announcementsData
              .map((json) => AnnouncementModel.fromJson(json))
              .where((announcement) {
            // Condition if the Date has ended or deadline has crossed
            if (!announcement.endDate!.toDate().isAfter(DateTime.now())) {
              return false;
            }

            // Condition when Student Didn't Logged in
            if (studentModel == null && announcement.gradYear!.contains("All")) {
              return true;
            }

            // Condition when Student Logged in
            if (studentModel != null) {
              // For All Gradyear
              if (announcement.gradYear!.contains("All")) {
                return true;
              }
              // Specific Gradyear
              if (announcement.gradYear == studentModel!.gradyear) {
                // all Branch
                if (announcement.branch!.contains("All")) {
                  return true;
                }
                // specific branch
                if (announcement.branch == studentModel!.branch) {
                  // All Division
                  if (announcement.div!.contains("All")) {
                    return true;
                  }
                  // specific div
                  if (announcement.div == studentModel!.div) {
                    // all batch
                    if (announcement.batch!.contains("All")) {
                      return true;
                    }
                    // specific batch
                    if (announcement.batch == studentModel!.batch) {
                      return true;
                    }
                  }
                }
              }
            }

            return false;
          }).toList();

          // Check if there are any announcements to display
          if (announcements.isEmpty) {
            return Center(
              child: Text(
                'No Announcement Available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[(announcements.length - 1) - index];
              return AnnouncementListItem(
                announcementModel: announcement,
              );
            },
          );
        },
      ),
    );
  }


  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else {
      return DateTime.now();
    }
  }

  Widget _buildDateHeader(DateTime date) {
    // Customize this method to build your date header
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.grey,
      child: Text(
        "${date.toLocal()}".split(' ')[0], // Display the date in a readable format
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AnnouncementListItem extends StatelessWidget {
  final AnnouncementModel announcementModel;

  AnnouncementListItem({required this.announcementModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(announcementModel.startDate==null || announcementModel.endDate==null){
      return const SizedBox();
    }
    DateTime startDate = announcementModel.startDate!.toDate();
    DateTime endDate = announcementModel.endDate!.toDate();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),

      child: Card(
        color: timePickerBg,
        child: Container(
          decoration: BoxDecoration(
          color: timePickerBg,
            border: Border.all(color: timePickerBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11.0,vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        announcementModel.title.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                      )
                    ),
                    if(announcementModel.docURL !=null && announcementModel.docURL !="")
                    InkWell(splashFactory: NoSplash.splashFactory,onTap: ()=>launchUrl(Uri.parse(announcementModel.docURL.toString(),),)
                      ,child:Icon(Icons.link,color: Colors.blue,),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                if(announcementModel.content != null || announcementModel.content!="")
                  Text(announcementModel.content.toString(),style: TextStyle(color: Colors.white),),
                SizedBox(height: 5),

              ],
            ),
          ),
        ),
      ),
    );
  }

  String getDateString(DateTime date){
    return "${date.day}/${date.month}/${date.year}";
  }
}

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}
