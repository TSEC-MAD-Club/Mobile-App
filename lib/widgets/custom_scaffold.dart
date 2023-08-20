import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/department_screen/department_screen.dart';
import 'package:tsec_app/screens/main_screen/widget/card_display.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/utils/timetable_util.dart';
import 'package:url_launcher/link.dart';
import '../models/notification_model/notification_model.dart';
import '../models/student_model/student_model.dart';
import '../provider/notification_provider.dart';
import '../provider/theme_provider.dart';
import '../screens/notification_screen/widgets/notification_dialog.dart';
import '../utils/image_assets.dart';
import '../utils/themes.dart';

class CustomScaffold extends ConsumerStatefulWidget {
  const CustomScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.hideButton,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool? hideButton;

  @override
  ConsumerState<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends ConsumerState<CustomScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: .6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hide = widget.hideButton ?? false;
    StudentModel? data = ref.watch(studentModelProvider);
    ref.listen<NotificationProvider?>(
      notificationProvider,
      (previous, next) {
        if (previous != next && next != null) {
          if (next.isForeground)
            showTopSnackBar(
              context,
              _ForegroundNotificationSnackBar(
                notificationModel: next.notificationModel!,
              ),
              onTap: () => GoRouter.of(context).push("/notifications"),
            );
          else
            showDialog(
              context: context,
              builder: (context) => NotificationDialog(
                notificationModel: next.notificationModel!,
              ),
            );
        }
      },
    );
    final size = MediaQuery.of(context).size;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            right: 15,
            child: Consumer(
              builder: (context, ref, child) => GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).switchTheme(),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconTheme(
                    data: const IconThemeData(color: kLightModeLightBlue),
                    child: ref.watch(themeProvider) == ThemeMode.dark
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 95,
            bottom: 75,
            right: 0,
            width: size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DrawerListItem(
                  onTap: () => _navigate("/main"),
                  icon: Image.asset(
                    ImageAssets.homeIcon,
                    width: 24,
                  ),
                  title: "Home",
                ),
                DrawerListItem(
                  onTap: () => _navigate("/tpc"),
                  icon: Image.asset(
                    ImageAssets.meetingIcon,
                    width: 22,
                  ),
                  title: "TPC",
                ),
                DrawerListItem(
                  onTap: () => _navigate("/committee"),
                  icon: Image.asset(
                    ImageAssets.committeesIcon,
                    width: 22,
                  ),
                  title: "Committees & Events",
                ),
                DrawerListItem(
                  onTap: () => _navigate("/department-list"),
                  icon: Image.asset(
                    ImageAssets.meetingIcon,
                    width: 22,
                  ),
                  title: "Departments",
                ),
                Link(
                  uri: Uri.parse("mailto:devsclubtsec@gmail.com"),
                  builder: (context, followLink) => DrawerListItem(
                    onTap: () => followLink?.call(),
                    icon: Image.asset(
                      ImageAssets.callIcon,
                      width: 24,
                    ),
                    title: "Contact Us",
                  ),
                ),
                data != null
                    ? DrawerListItem(
                        onTap: () => _navigate("/profile-page"),
                        icon: Image.asset(
                          ImageAssets.meetingIcon,
                          width: 22,
                        ),
                        title: "Profile",
                      )
                    : Container(),
                // DrawerListItem(
                //   onTap: () => _navigate("/profile-page"),
                //   icon: Image.asset(
                //     ImageAssets.meetingIcon,
                //     width: 22,
                //   ),
                //   title: "Profile",
                // ),
                DrawerListItem(
                  onTap: () async {
                    final _messaging = FirebaseMessaging.instance;

                    if (data != null) {
                      ref
                          .read(studentModelProvider.notifier)
                          .update((state) => null);
                      _messaging
                          .unsubscribeFromTopic(NotificationType.notification);
                      _messaging.unsubscribeFromTopic(
                          NotificationType.yearBranchDivBatchTopic);
                      _messaging.unsubscribeFromTopic(
                          NotificationType.yearBranchDivTopic);
                      _messaging.unsubscribeFromTopic(
                          NotificationType.yearBranchTopic);
                      _messaging
                          .unsubscribeFromTopic(NotificationType.yearTopic);
                    }
                    ref.watch(authProvider.notifier).signout();
                    GoRouter.of(context).go('/login');
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 22.0,
                    color: Colors.blue,
                  ),
                  title: data != null ? "Logout" : "Login",
                ),
              ],
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: _controller,
            builder: (context, value, child) {
              // If drawer is not open directly return scaffold
              if (value == 0.0) return child!;

              final borderRadius = BorderRadius.circular(30 * value);
              return Transform.translate(
                offset: Offset(-size.width / 2 * value, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.lerp(
                          null,
                          Border.all(color: kDarkModeDarkBlue),
                          value,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3322ABE5),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(3, 3),
                          )
                        ],
                        borderRadius: borderRadius,
                      ),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Scaffold(
              appBar: !hide ? widget.appBar : null,
              body: SafeArea(child: widget.body ?? Container()),
            ),
          ),
          !hide
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                        onTap: () {
                          if (_controller.isCompleted) {
                            _controller.reverse();
                          } else {
                            _controller.forward();
                          }
                          overlayEntry?.remove();
                          overlayEntry = null;
                          ref
                              .read(dayProvider.notifier)
                              .update((state) => DateTime.now());
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(13),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF136ABF),
                                Color(0xFF4391DE),
                              ],
                            ),
                          ),
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) => Transform.rotate(
                              angle: math.pi * _controller.value,
                              child: _controller.value > .5
                                  ? const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : CustomPaint(
                                      painter: _MenuIconPainter(),
                                    ),
                            ),
                          ),
                        )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> _navigate(String path) async {
    await _controller.reverse();

    final router = GoRouter.of(context);
    if (router.location != path) router.push(path);
  }
}

class _ForegroundNotificationSnackBar extends StatelessWidget {
  const _ForegroundNotificationSnackBar({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kDarkModeDarkBlue),
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.notifications_active,
              color: kDarkModeDarkBlue,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notificationModel.title,
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (notificationModel.attachments != null)
                        const Icon(
                          Icons.attach_file,
                          size: 15,
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notificationModel.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListItem extends StatelessWidget {
  const DrawerListItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            icon,
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is generated using fluttershapemaker.com
class _MenuIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06666667
      ..color = const Color(0xffF2F5F8)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(size.width * 0.4478167, size.height * 0.09358714),
        Offset(size.width * 0.9595000, size.height * 0.09358714), paint);

    canvas.drawLine(Offset(size.width * 0.06296800, size.height * 0.5221571),
        Offset(size.width * 0.9595000, size.height * 0.5221571), paint);

    canvas.drawLine(Offset(size.width * 0.06296800, size.height * 0.9507286),
        Offset(size.width * 0.6659967, size.height * 0.9507286), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
