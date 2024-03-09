import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/init_get_it.dart';
import 'package:tsec_app/utils/storage_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DownloadButton extends ConsumerStatefulWidget {
  final String url;
  Function removeFile;
  DownloadButton({
    Key? key,
    required this.url,
    required this.removeFile,
  }) : super(key: key);

  @override
  ConsumerState<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends ConsumerState<DownloadButton> {
  late final StorageUtil _storage;
  StorageResult? _storageResult;
  double _downloadPrecent = 0;
  @override
  void initState() {
    super.initState();
    debugPrint(widget.url);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _storage = locator<StorageUtil>();
      if (widget.url.startsWith("http")) {
        _storage
            .getResult(widget.url)
            .then((value) => setState(() => _storageResult = value));
      } else {
        setState(() {
          _storageResult = StorageResult(
              name: Uri.parse(widget.url).pathSegments.last,
              url: widget.url,
              path: widget.url);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = ref.watch(userModelProvider)!;
    // debugPrint(_storageResult?.path);
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.0,
      ),
      child: GestureDetector(
        onTap: () {
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _storageResult!.name,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // !user.isStudent
                  // ? GestureDetector(
                  !user.isStudent
                      ? GestureDetector(
                          onTap: () => widget.removeFile(),
                          child: Icon(
                            Icons.cancel,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        )
                      : Container()
                  // : Container(),
                ],
              ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(top: 0),
    //   child: TextButton(
    //     style: ElevatedButton.styleFrom(
    //         foregroundColor: Colors.white, backgroundColor: Colors.transparent),
    //     onPressed: () {
    //       _onButtonClick(widget.url);
    //     },
    //     child: _storageResult == null || _storageResult!.isDownloadInProgress
    //         ? SizedBox(
    //             height: 24,
    //             width: 24,
    //             child: CircularProgressIndicator(
    //               value: _downloadPrecent <= 0 ? null : _downloadPrecent,
    //             ),
    //           )
    //         : SizedBox(
    //             child: SingleChildScrollView(
    //               physics: const BouncingScrollPhysics(),
    //               scrollDirection: Axis.horizontal,
    //               child: ConstrainedBox(
    //                 constraints: BoxConstraints(
    //                   maxWidth: MediaQuery.of(context).size.width,
    //                 ),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: <Widget>[
    //                     _storageResult!.path != null
    //                         ? const Icon(
    //                             Icons.open_in_new,
    //                             color: Colors.blue,
    //                           )
    //                         : const Icon(
    //                             Icons.download,
    //                             color: Colors.blue,
    //                           ),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     Text(
    //                       _storageResult!.name,
    //                       style: TextStyle(
    //                           decoration: TextDecoration.underline,
    //                           color: Colors.blue.shade400,
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.bold),
    //                       // textAlign: TextAlign.center,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //   ),
    // );
  }

  void launchUrlNotification(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url.toString());
    } else
      throw "Could not launch url";
  }

  void _onButtonClick(String url) {
    if (_storageResult!.path != null) {
      debugPrint(_storageResult!.path);
      OpenFile.open(_storageResult!.path!);

      return;
    }
    showSnackBar(context, "Downloading selected file");
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
