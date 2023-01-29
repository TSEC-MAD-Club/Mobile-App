import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/provider/app_state_provider.dart';

import '../utils/image_assets.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (ref.read(appStateProvider).isFirstOpen) {
        GoRouter.of(context).go('/theme');
      } else {
        GoRouter.of(context).go('/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Image.asset(ImageAssets.tsecapplogo),
          height: 250,
          width: 250,
        ),
      ),
    );
  }
}
