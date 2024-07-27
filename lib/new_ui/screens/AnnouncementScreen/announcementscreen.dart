import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../models/announcement_model/announcement_model.dart';
import 'announcementmodel.dart';

class AnnouncementScreen extends StatelessWidget {
  final DateTime _lastDate = DateTime.now();

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            // You can add a header here if needed
          ),
        ],
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('ImportantNotice').doc('Content').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              final List<dynamic> announcementsData = data?['content'] ?? [];

              final announcements = announcementsData.map((json) => AnnouncementModel.fromJson(json)).toList();
              return ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  final listTile = AnnouncementListItem(
                    announcementModel: announcement,
                  );

                  if (_lastDate.isSameDate(_parseTimestamp(announcement.startDate))) {
                    return listTile;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //_buildDateHeader(_parseTimestamp(announcement.startDate)),
                      listTile,
                    ],
                  );
                },
              );
            }
          },
        ),
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
    if(announcementModel.docURL == null || announcementModel.startDate==null || announcementModel.endDate==null){
      return const SizedBox();
    }
    DateTime startDate = announcementModel.startDate!.toDate();
    DateTime endDate = announcementModel.endDate!.toDate();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: timePickerBg,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0,vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(announcementModel.title.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
              SizedBox(height: 5),
              if(announcementModel.content != null)
                Text(announcementModel.content.toString()),
              /*Row(
                children: [
                  Text("From :- ${getDateString(startDate)}"),
                  Spacer(),
                  Text("Till :- ${getDateString(endDate)}"),
                ],
              ),*/
              SizedBox(height: 5),
              InkWell(splashFactory: NoSplash.splashFactory,onTap: ()=>launchUrl(Uri.parse(announcementModel.docURL.toString(),),),child: Row(
                children: [
                  Icon(Icons.link),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Check out this Link",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),),
                ],
              ),),
            ],
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
