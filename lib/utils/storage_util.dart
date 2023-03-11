import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum DownloadStatus { downloaded, inProgress, notDownloaded }

class StorageUtil {
  final FirebaseStorage _storage;

  StorageUtil([FirebaseStorage? storage])
      : _storage = storage ?? FirebaseStorage.instance;

  Future<StorageResult> getResult(String url) async {
    final res = _storage.refFromURL(url);
    final metaData = await res.getMetadata();
    final file = await _getFile(res.name);
    final isDownloaded = await file.exists();

    return StorageResult(
      name: res.name,
      url: url,
      path: isDownloaded ? file.path : null,
      type: metaData.contentType,
    );
  }

  // if progress returns -ive then size is not determined
  Future<void> downloadFile({
    required StorageResult result,
    required Function(double, String) progress,
  }) async {
    const storage = Permission.storage;

    if (await storage.isDenied) storage.request();

    if (await storage.isGranted) {
      final res = _storage.refFromURL(result.url);

      final file = (await _getFile(result.name))..createSync(recursive: true);
      final task = res.writeToFile(file);
      task.snapshotEvents.listen((taskSnap) {
        progress(taskSnap.bytesTransferred / taskSnap.totalBytes, file.path);
      });
    }
  }

  Future<File> _getFile(String name) async {
    Directory tempDir = await getTemporaryDirectory(); 
    String path = tempDir.path;
    // final path = await getExternalStorageDirectories(
    //   type: StorageDirectory.pictures,
    // );
    return File("$path/$name");
  }
}

class StorageResult {
  final String name, url;
  final String? path, type;
  final bool isDownloadInProgress;

  StorageResult({
    required this.name,
    required this.url,
    this.isDownloadInProgress = false,
    this.path,
    this.type,
  });

  StorageResult updateDownloadStatus({
    required bool status,
    String? path,
  }) {
    return StorageResult(
      name: name,
      isDownloadInProgress: status,
      url: url,
      path: path,
    );
  }
}
