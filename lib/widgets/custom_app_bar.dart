import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/utils/image_assets.dart';

import '../provider/theme_provider.dart';
import '../utils/themes.dart';

class CustomAppBar extends ConsumerWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  Widget _buildImageChild() {
    if (title == "Committees & Events") {
      return Image.asset(
        ImageAssets.committes,
        width: 177,
      );
    } else if (title == "Training & Placement Cell") {
      return Image.asset(
        ImageAssets.tpo,
        width: 177,
      );
    } else if (title == "") {
      return Image.asset(ImageAssets.committes, width: 177);
    }
    return const SizedBox(width: 177);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        height: 235,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildNavigation(
                    context,
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final theme = ref.watch(themeProvider);
                      return _buildNavigation(
                        context,
                        icon: theme == ThemeMode.dark
                            ? const Icon(Icons.light_mode)
                            : const Icon(Icons.dark_mode),
                        onPressed: () {
                          ref.read(themeProvider.notifier).switchTheme();
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Flexible(child: _buildImageChild())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconTheme(
          data: const IconThemeData(color: kLightModeLightBlue),
          child: icon,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(235);
}
