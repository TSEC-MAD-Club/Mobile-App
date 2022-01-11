import 'package:flutter/material.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';
import 'package:tsec_app/screens/notification_screen/widgets/notification_dialog.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          notificationModel: notificationModel,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    notificationModel.title,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (notificationModel.attachments != null)
                  const Icon(
                    Icons.attach_file,
                    size: 15,
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              notificationModel.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
