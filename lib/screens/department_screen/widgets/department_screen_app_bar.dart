import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/themes.dart';

class DepartmentScreenAppBar extends ConsumerStatefulWidget
    with PreferredSizeWidget {
  final String title;
  const DepartmentScreenAppBar({Key? key, required this.title})
      : super(key: key);

  @override
  _DepartmentScreenAppBarState createState() => _DepartmentScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _DepartmentScreenAppBarState
    extends ConsumerState<DepartmentScreenAppBar> {
  Widget _buildNavigation(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 0),
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

  Widget _buildThemeSwitcher(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5),
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
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 60.0,
      toolbarHeight: 65.0,
      leading: _buildNavigation(
        context,
        onPressed: () => GoRouter.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 30,
        ),
      ),
      title: Text(
        "Department",
        style: Theme.of(context).textTheme.headline6,
      ),
      centerTitle: true,
      actions: [
        _buildThemeSwitcher(context, onPressed: () {
          GoRouter.of(context).push('/notifications');
        }, icon: const Icon(Icons.notifications)),
      ],
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
