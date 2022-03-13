import 'package:flutter/material.dart';

import '../../../utils/themes.dart';

class CurriculumSection extends StatefulWidget {
  const CurriculumSection({Key? key}) : super(key: key);

  @override
  State<CurriculumSection> createState() => _CurriculumSectionState();
}

class _CurriculumSectionState extends State<CurriculumSection> {
  String _selectedSem = "1";

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _buildButton(sem: "${index + 1}"),
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemCount: 8,
          ),
        ),
        IconTheme(
          data: const IconThemeData(color: kLightModeLightBlue),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                5,
                (index) => _buildSubjects("Subject $index"),
              ),
            ),
          ),
        ),
        // Added row to make sure that it wont take whole
        // width because of ListView
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Theme.of(context).textTheme.bodyText2!.color,
                  textStyle: Theme.of(context).textTheme.bodyText2,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {},
                child: const Text("Download full syllabus"),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              _buildDownloadColumn(
                title: "Timetable",
                onPressed: () {},
              ),
              const SizedBox(width: 20),
              _buildDownloadColumn(
                title: "Academic Calendar",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadColumn({
    required String title,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: Theme.of(context).textTheme.bodyText2!.color,
              textStyle: Theme.of(context).textTheme.bodyText2,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: onPressed,
            child: const Text("Download"),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjects(String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.chevron_right_rounded),
        const SizedBox(width: 3),
        Flexible(child: Text(name)),
      ],
    );
  }

  Widget _buildButton({required String sem}) {
    final isSelected = sem == _selectedSem;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _selectedSem = sem),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 7,
              color: kLightModeLightBlue.withOpacity(0.23),
            )
          ],
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kDarkModeDarkBlue, kDarkModeLightBlue],
                )
              : null,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        child: Text(
          "Sem\n$sem",
          textAlign: TextAlign.center,
          style: isSelected ? const TextStyle(color: Colors.white) : null,
        ),
      ),
    );
  }
}
