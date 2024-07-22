import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/services/sharedprefsfordot.dart';

final sharedPreferencesForDotProvider = FutureProvider<dotClass>((ref) async{
  final instance = dotClass();
  await instance.initializeSharedPreferences();
  return instance;
});