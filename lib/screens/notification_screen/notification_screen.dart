import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/screens/notification_screen/widgets/notification_list_item.dart';
import 'package:tsec_app/services/notification_service.dart';
import 'package:tsec_app/utils/init_get_it.dart';

import '../../models/notification_model/notification_model.dart';
import '../../utils/image_assets.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_scaffold.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime _lastDate = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Notifications",
              image: Image.asset(ImageAssets.committes),
            ),
          )
        ],
        body: FirestoreListView<NotificationModel>(
          query: locator<NotificationService>()
              .notificationQuery
              .orderBy("notificationTime", descending: true),
          itemBuilder: (context, doc) {
            final data = doc.data();

            final listTile = NotificationListItem(notificationModel: data);

            if (_lastDate.isSameDate(data.notificationTime)) return listTile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateHeader(data.notificationTime),
                listTile,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime notificationTime) {
    _lastDate = notificationTime;
    return Center(
      child: Chip(
        labelStyle: const TextStyle(fontSize: 12),
        label: Text(
          DateFormat("dd MMMM,yyyy").format(notificationTime),
        ),
      ),
    );
  }
}
