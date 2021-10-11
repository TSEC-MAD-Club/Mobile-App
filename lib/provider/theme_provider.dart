import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_prefs_provider.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeMode>((ref) {
  return ThemeProvider(ref.watch(sharedPrefsProvider));
});

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider(this.sharedPrefsProvider)
      : super(_getTheme(sharedPrefsProvider));

  final SharedPrefsProvider sharedPrefsProvider;

  static ThemeMode _getTheme(SharedPrefsProvider sharedPreferences) =>
      ThemeMode.values[sharedPreferences.theme];

  void _setTheme(ThemeMode theme) {
    sharedPrefsProvider.theme = theme.index;
    state = theme;
  }

  void switchTheme() {
    _setTheme(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
