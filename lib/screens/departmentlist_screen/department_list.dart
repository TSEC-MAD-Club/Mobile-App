import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';
import 'package:tsec_app/screens/department_screen/widgets/department_screen_app_bar.dart';

import '../../utils/department_enum.dart';
import '../../widgets/custom_scaffold.dart';

class DepartmentListScreen extends StatelessWidget {
  const DepartmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: DepartmentList(),
      ),
    );
  }
}

class DepartmentList extends StatelessWidget {
  const DepartmentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text("Department", style: Theme.of(context).textTheme.titleLarge),
            // ),
            const DeptWidget(
              image: "aids",
              department: DepartmentEnum.aids,
            ),
            const DeptWidget(
              image: "extc",
              department: DepartmentEnum.extc,
            ),
            const DeptWidget(
              image: "cs",
              department: DepartmentEnum.cs,
            ),
            const DeptWidget(
              image: "it",
              department: DepartmentEnum.it,
            ),
            const DeptWidget(
              image: "biomed",
              department: DepartmentEnum.biomed,
            ),
            const DeptWidget(
              image: "biotech",
              department: DepartmentEnum.biotech,
            ),
            const DeptWidget(
              image: "chem",
              department: DepartmentEnum.chem,
            ),
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
    final size = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(
        "/department?department=${department.index}",
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.outline,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.outline,
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/branches/$image.png",
                    height: 40,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded( // Ensures the text takes up remaining space
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      department.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2, // Adjust max lines as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
