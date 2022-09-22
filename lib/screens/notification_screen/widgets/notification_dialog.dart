import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';

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
      padding: const EdgeInsets.only(top: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
        onPressed: _storageResult == null ? null : _onButtonClick,
        child: _storageResult == null || _storageResult!.isDownloadInProgress
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  value: _downloadPrecent <= 0 ? null : _downloadPrecent,
                ),
              )
            : Row(
                children: <Widget>[
                  _storageResult!.path != null
                      ? const Icon(Icons.open_in_new)
                      : const Icon(Icons.download),
                  Expanded(
                    child: Text(
                      _storageResult!.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _onButtonClick() {
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
  }
}
