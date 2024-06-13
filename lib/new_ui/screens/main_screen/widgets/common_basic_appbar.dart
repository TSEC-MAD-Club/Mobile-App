import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/appbar_title_provider.dart';

class CommonAppbar extends ConsumerWidget implements PreferredSizeWidget{
  const CommonAppbar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.read(titleProvider);
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      toolbarHeight: 80,
      title: Text(title,
        style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(fontSize: 15, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.fade,),
        centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
