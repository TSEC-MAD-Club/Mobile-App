import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import '../models/announcement_model/announcement_model.dart';
import 'announcementmodel.dart';

class AnnouncementScreen extends StatelessWidget {
  final DateTime _lastDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              print("in announcement screen ppppppppppppppppppppppppppppppppppppppp");
              print(data);

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
                      _buildDateHeader(_parseTimestamp(announcement.startDate)),
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
      padding: EdgeInsets.all(8.0),
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
    return ListTile(
      title: Text(announcementModel.title ?? "No Title"),
      subtitle: Text(announcementModel.docURL ?? "No URL"),
      // Add other fields as needed
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}
