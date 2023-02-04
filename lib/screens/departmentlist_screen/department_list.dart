import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/screens/department_screen/widgets/department_screen_app_bar.dart';

import '../../utils/department_enum.dart';
import '../../widgets/custom_scaffold.dart';

class DepartmentListScreen extends StatelessWidget {
  const DepartmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      appBar: DepartmentScreenAppBar(title: 'Department'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            DepartmentList(),
          ],
        ),
      ),
    );
  }
}

class DepartmentList extends StatelessWidget {
  const DepartmentList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        childAspectRatio:
            (MediaQuery.of(context).size.width > 400) ? 1.5 : 173 / 224,
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
                    height: 150,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(department.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
