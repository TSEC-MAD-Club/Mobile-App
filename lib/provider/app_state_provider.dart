import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_prefs_provider.dart';

final appStateProvider = ChangeNotifierProvider<AppStateProvider>((ref) {
  return AppStateProvider(ref.read(sharedPrefsProvider));
});

class AppStateProvider extends ChangeNotifier {
  AppStateProvider(this._sharedPrefsProvider);

  final SharedPrefsProvider _sharedPrefsProvider;

  bool get isFirstOpen => _sharedPrefsProvider.isFirstOpen;

  Future<void> appOpened() => _sharedPrefsProvider.appOpened().then((_) {
        notifyListeners();
      });
}
