import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text(
            notificationModel.title,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(notificationModel.message),
          if (notificationModel.attachments != null) ...[
            const SizedBox(height: 20),
            ..._buildDownloadButtons(notificationModel.attachments!),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildDownloadButtons(List<String> urls) {
    final _storage = FirebaseStorage.instance;
    return urls.map(
      (url) {
        final _ref = _storage.refFromURL(url);
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(onPrimary: Colors.white),
            onPressed: () {},
            child: Row(
              children: <Widget>[
                const Icon(Icons.download),
                Expanded(
                  child: Text(
                    _ref.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }
}
