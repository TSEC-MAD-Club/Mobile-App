import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsec_app/screens/department_screen/department_screen.dart';

import 'provider/shared_prefs_provider.dart';
import 'provider/theme_provider.dart';
import 'utils/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(SharedPrefsProvider(_sharedPrefs))
      ],
      child: const TSECApp(),
    ),
  );
}

class TSECApp extends ConsumerWidget {
  const TSECApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _themeMode = watch(themeProvider);
    return MaterialApp(
      title: 'TSEC App',
      themeMode: _themeMode,
      theme: theme,
      darkTheme: darkTheme,
      home:
          DepartmentScreen(departmentName: "Electronics &\nTelecommunication"),
    );
  }
}
