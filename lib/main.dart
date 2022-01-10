import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsec_app/utils/init_get_it.dart';

import 'firebase_options.dart';
import 'provider/shared_prefs_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/notification_screen/notification_screen.dart';
import 'utils/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initGetIt();

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
      home: const NotificationScreen(),
    );
  }
}
