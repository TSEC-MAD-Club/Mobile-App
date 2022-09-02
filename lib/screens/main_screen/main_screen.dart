import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/theme_provider.dart';
import '../../utils/department_enum.dart';
import '../../utils/image_assets.dart';
import '../../utils/launch_url.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_scaffold.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MainScreenAppBar(sidePadding: _sidePadding),
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  "assets/images/branches/$image.png",
                  height: 100,
                ),
              ),
              Text(department.getName),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreenAppBar extends ConsumerWidget {
  MainScreenAppBar({
    Key? key,
    required EdgeInsets sidePadding,
  })  : _sidePadding = sidePadding,
        super(key: key);

  final EdgeInsets _sidePadding;
  final List<String> imgList = [
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: _sidePadding.copyWith(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Text(
                  "Thadomal Shahani Engineering College",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () => ref.read(themeProvider.notifier).switchTheme(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const IconTheme(
                      data: IconThemeData(color: kLightModeLightBlue),
                      child: Icon(Icons.dark_mode),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => launchUrl(
              "https://goo.gl/maps/5DzApsKqUQ91T5yK7",
              context,
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  ImageAssets.locationIcon,
                  width: 20,
                ),
                Text(
                  "Bandra, Mumbai",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText1!
                      .copyWith(color: kLightModeDarkBlue),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          CarouselSlider(
            items: imgList
                .map(
                  (item) => GestureDetector(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                          )),
                      onTap: () => GoRouter.of(context).push("/details_page")),
                )
                .toList(),
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                viewportFraction: 1),
          ),
        ],
      ),
    );
  }
}
