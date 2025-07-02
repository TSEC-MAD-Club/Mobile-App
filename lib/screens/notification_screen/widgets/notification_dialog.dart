import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/notification_model/notification_model.dart';
import '../../../utils/init_get_it.dart';
import '../../../utils/storage_util.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: commonbgblack,
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text(
            notificationModel.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            notificationModel.message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          if (notificationModel.attachments != null) ...[
            const SizedBox(height: 20),
            ..._buildDownloadButtons(notificationModel.attachments!),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildDownloadButtons(List<String> urls) {
    return urls.map((url) => _DownloadButton(url: url)).toList();
  }
}

class _DownloadButton extends StatefulWidget {
  const _DownloadButton({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  late final StorageUtil _storage;
  StorageResult? _storageResult;
  double _downloadPrecent = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _storage = locator<StorageUtil>();
      _storage
          .getResult(widget.url)
          .then((value) => setState(() => _storageResult = value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: TextButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.transparent),
        onPressed: () {
          _onButtonClick(widget.url);
        },
        child: _storageResult == null || _storageResult!.isDownloadInProgress
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  value: _downloadPrecent <= 0 ? null : _downloadPrecent,
                ),
              )
            : SizedBox(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _storageResult!.path != null
                            ? const Icon(
                                Icons.open_in_new,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.download,
                                color: Colors.blue,
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          _storageResult!.name,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          // textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void launchUrlNotification(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url.toString(),
          mode: LaunchMode.externalApplication);
    } else
      throw "Could not launch url";
  }

  void _onButtonClick(String url) {
    showSnackBar(context, "Downloading Attachment ");
    if (_storageResult!.path != null) {
      OpenFile.open(_storageResult!.path!, type: _storageResult!.type);

      return;
    }
    _storageResult = _storageResult!.updateDownloadStatus(status: true);
    _storage.downloadFile(
      result: _storageResult!,
      progress: (percentage, path) {
        setState(() {
          _downloadPrecent = percentage;
          if (_downloadPrecent == 1.0)
            _storageResult = _storageResult!.updateDownloadStatus(
              status: false,
              path: path,
            );
        });
      },
    );
    if (_storageResult!.path != null) {
      OpenFile.open(_storageResult!.path!, type: _storageResult!.type);
      return;
    }
    launchUrlNotification(url);
  }
}
