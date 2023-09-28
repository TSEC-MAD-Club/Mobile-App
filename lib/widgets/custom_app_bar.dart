import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/themes.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.title,
    required this.image,
  }) : super(key: key);

  final String title;
  final Image image;

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
                  SizedBox(
                    width: 177,
                    child: image,
                  )
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
