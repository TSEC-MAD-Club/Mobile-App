import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider<SharedPrefsProvider>((_) {
  throw UnimplementedError();
});

class SharedPrefsProvider {
  SharedPrefsProvider(this._sharedPrefs);

  final SharedPreferences _sharedPrefs;

  static const _themeKey = "theme";
  static const _isFirstOpen = "isFirstOpen";

  int get theme => _sharedPrefs.getInt(_themeKey) ?? ThemeMode.light.index;

  set theme(int theme) {
    _sharedPrefs.setInt(_themeKey, theme);
  }

  bool get isFirstOpen => _sharedPrefs.getBool(_isFirstOpen) ?? true;

  Future<bool> appOpened() => _sharedPrefs.setBool(_isFirstOpen, false);
}
