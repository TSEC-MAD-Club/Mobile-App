import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/profile_screen/profile_screen.dart';
import '../../../utils/themes.dart';

class RailwayAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  const RailwayAppBar({Key? key, required this.title}) : super(key: key);

  @override
  __RailwayAppBarStateState createState() => __RailwayAppBarStateState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class __RailwayAppBarStateState extends ConsumerState<RailwayAppBar> {
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

  Widget _buildNotificationIcon(
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
        onPressed: () => GoRouter.of(context).go('/main'),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 30,
        ),
      ),
      title: Text(
        "Railway Concession",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        // IconButton(
        //     onPressed: () {
        //       print("Pressed");
        //       setState(() {
        //       });
        //     },
        //     icon: Icon(Icons.edit))
      ],
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
