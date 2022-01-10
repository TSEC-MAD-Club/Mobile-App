import 'package:get_it/get_it.dart';
import 'package:tsec_app/services/notification_service.dart';
import 'package:tsec_app/utils/storage_util.dart';

final locator = GetIt.instance;

void initGetIt() {
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => StorageUtil());
}
