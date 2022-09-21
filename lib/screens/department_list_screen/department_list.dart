// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../provider/theme_provider.dart';
// import 'widgets/custom_card.dart';

// class CalenderScreen extends ConsumerWidget {
//   CalenderScreen({Key? key}) : super(key: key);

//   final colorList = [Colors.red, Colors.teal, Colors.blue];
//   final opacityList = const [
//     Color.fromRGBO(255, 0, 0, 0.2),
//     Color.fromARGB(51, 0, 255, 225),
//     Color.fromARGB(51, 0, 153, 255),
//   ];

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _size = MediaQuery.of(context).size;
//     var _theme = Theme.of(context);
//     var _boxshadow = BoxShadow(
//       color: _theme.primaryColorDark,
//       spreadRadius: 2,
//       blurRadius: 8,
//       offset: const Offset(0, 1),
//     );

//     return Scaffold(
//       backgroundColor: _theme.primaryColor,
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             Container(
//               height: _size.height * 0.25,
//               width: _size.width,
//               decoration: BoxDecoration(
//                 color: _theme.primaryColor,
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(50.0),
//                 ),
//                 boxShadow: [_boxshadow],
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 20.0,
//                     right: 20.0,
//                     child: Container(
//                       height: 40.0,
//                       width: 40.0,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: _theme.primaryColor,
//                       ),
//                       child: IconButton(
//                         color: Colors.blue,
//                         onPressed: () =>
//                             ref.read(themeProvider.notifier).switchTheme(),
//                         icon: const Icon(
//                           Icons.light_mode,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 20.0,
//                     left: 20.0,
//                     child: Container(
//                       height: 40.0,
//                       width: 40.0,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: _theme.primaryColor,
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           GoRouter.of(context).pop();
//                         },
//                         icon: const Padding(
//                           padding: EdgeInsets.only(left: 5.0),
//                           child: Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 80.0,
//                     left: 20.0,
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 28.0,
//                           backgroundImage: NetworkImage(
//                               'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.dailypioneer.com%2Fuploads%2F2020%2Fstory%2Fimages%2Fbig%2Felon-musk-hires-ai-that--reports-directly--to-him-24-7-2020-02-03.jpg&f=1&nofb=1'),
//                         ),
//                         const Padding(padding: EdgeInsets.only(left: 15.0)),
//                         SizedBox(
//                           height: 100.0,
//                           width: 180.0,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text(
//                                 'Hi, John',
//                                 style: _theme.textTheme.headline1,
//                               ),
//                               Text(
//                                 'List of schedlue you need to check...',
//                                 style: _theme.textTheme.subtitle1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Container(
//               width: _size.width * 0.9,
//               decoration: BoxDecoration(
//                 color: _theme.primaryColor,
//                 borderRadius: BorderRadius.circular(15.0),
//                 border: Border.all(
//                   color: _theme.primaryColorLight,
//                   width: 1,
//                   style: BorderStyle.solid,
//                 ),
//                 boxShadow: [_boxshadow],
//               ),
//               child: DatePicker(
//                 DateTime.now(),
//                 monthTextStyle: _theme.textTheme.subtitle2!,
//                 dayTextStyle: _theme.textTheme.subtitle2!,
//                 dateTextStyle: _theme.textTheme.subtitle2!,
//                 initialSelectedDate: DateTime.now(),
//                 selectionColor: Colors.blue,
//                 daysCount: 7,
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 15.0,
//               ),
//               child: SizedBox(
//                 height: _size.height * 0.6,
//                 width: _size.width,
//                 child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: 3,
//                     itemBuilder: (context, value) {
//                       var color = colorList[value];
//                       var opacity = opacityList[value];
//                       return CustomCard(
//                         color,
//                         opacity,
//                       );
//                     }),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/department_enum.dart';
import '../../widgets/custom_scaffold.dart';

class DepartmentListScreen extends StatelessWidget {
  const DepartmentListScreen({super.key});
  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return CustomScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: _theme.primaryColor,
                  ),
                  child: IconButton(
                    // alignment: Alignment.centerLeft,
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: _sidePadding.copyWith(top: 15),
                child: Text(
                  "Departments",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                childAspectRatio: 173 / 224,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: const [
                  DeptWidget(
                    image: "aids",
                    department: DepartmentEnum.aids,
                  ),
                  DeptWidget(
                    image: "extc",
                    department: DepartmentEnum.extc,
                  ),
                  DeptWidget(
                    image: "cs",
                    department: DepartmentEnum.cs,
                  ),
                  DeptWidget(
                    image: "it",
                    department: DepartmentEnum.it,
                  ),
                  DeptWidget(
                    image: "biomed",
                    department: DepartmentEnum.biomed,
                  ),
                  DeptWidget(
                    image: "biotech",
                    department: DepartmentEnum.biotech,
                  ),
                  DeptWidget(
                    image: "chem",
                    department: DepartmentEnum.chem,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeptWidget extends StatelessWidget {
  const DeptWidget({
    Key? key,
    required this.image,
    required this.department,
  }) : super(key: key);

  final String image;
  final DepartmentEnum department;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(
        "/department?department=${department.index}",
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/images/branches/$image.png",
                    height: 100,
                  ),
                ),
              ),
              Text(department.name),
            ],
          ),
        ),
      ),
    );
  }
}
