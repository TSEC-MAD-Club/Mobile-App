//import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/provider/notification_provider.dart';
import 'package:tsec_app/screens/notification_screen/widgets/notification_list_item.dart';
import 'package:tsec_app/services/notification_service.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
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

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  DateTime _lastDate = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Notifications",
              image: Image.asset(ImageAssets.committes),
            ),
          ),
        ],
        //body: Column(),
        body: ref.watch(notificationListProvider).when(
            data: (data){
              final notifications = data.docs;
              return ListView.builder(itemCount: notifications.length, itemBuilder: (context, index){
                final notif = NotificationModel.fromJson(notifications[index].data() as Map<String, dynamic>);
                print(notif.attachments.toString());
                final listTile = NotificationListItem(
                  notificationModel: notif,
                );
                if (_lastDate.isSameDate(notif.notificationTime)) return listTile;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDateHeader(notif.notificationTime),
                    listTile,
                  ],
                );
              });
            },
            error: (error, stacktrace){return Center(child: Text(error.toString(), style: TextStyle(color: Colors.white),),);},
            loading: (){return Column();}),

        /*body: FirestoreListView<NotificationModel>(
          query: locator<NotificationService>()
              .notificationQuery
              .orderBy("notificationTime", descending: true),
          itemBuilder: (context, doc) {
            final data = doc.data();

            final listTile = NotificationListItem(
              notificationModel: data,
            );

            if (_lastDate.isSameDate(data.notificationTime)) return listTile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateHeader(data.notificationTime),
                listTile,
              ],
            );
          },
        ),*/
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
