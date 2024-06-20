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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => NotificationDialog(
            notificationModel: notificationModel,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notificationModel.title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (notificationModel.attachments != null)
                    Icon(
                      Icons.attach_file,
                      size: 20,
                      color: (Theme.of(context).primaryColor ==
                              const Color(0xFFF2F5F8))
                          ? Colors.black12
                          : Colors.white12,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                notificationModel.message,
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Divider(
                color: Colors.white12,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
