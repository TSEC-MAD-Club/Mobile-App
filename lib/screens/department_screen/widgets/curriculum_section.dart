import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../utils/department_enum.dart';
import '../../../utils/init_get_it.dart';
import '../../../utils/storage_util.dart';
import '../../../utils/themes.dart';

class CurriculumSection extends StatefulWidget {
  const CurriculumSection({Key? key, required this.department}) : super(key: key);

  final DepartmentEnum department;

  @override
  State<CurriculumSection> createState() => _CurriculumSectionState();
}

class _CurriculumSectionState extends State<CurriculumSection> {
  String _selectedSem = "1";

  late final Future<Map<String, dynamic>> _curriculumDetails;
  final StorageUtil _storage = locator<StorageUtil>();
  StorageResult? _storageResult;
  double _downloadPrecent = 0;

  @override
  void initState() {
    super.initState();

    _curriculumDetails = rootBundle.loadStructuredData(
      "assets/data/curriculum_data/${widget.department.fileName}.json",
      (value) async => jsonDecode(value) as Map<String, dynamic>,
    );

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _storage = locator<StorageUtil>();
    //   _storage
    //       .getResult(widget.url)
    //       .then((value) => setState(() => _storageResult = value));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _curriculumDetails,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final data = snapshot.data!;
        final semData = data[_selectedSem];
        final subjects = (semData["subjects"] as List) //
            .map((e) => e as String)
            .toList();
        final url = semData["url"] as String;

        _storage.getResult(url).then((value) {
          if (!mounted) return;
          setState(() => _storageResult = value);
        });

        return Flexible(
          flex: 1,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 100,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildButton(sem: "${index + 1}");
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemCount: 8,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 7,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    IconTheme(
                      data: IconThemeData(color: Theme.of(context).colorScheme.outline),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          subjects.length,
                          (index) => _buildSubjects(subjects[index]),
                        ),
                      ),
                    ),

                    // Added row to make sure that it wont take whole
                    // width because of ListView
                    Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: Theme.of(context).textTheme.titleSmall,
                                  backgroundColor: Theme.of(context).colorScheme.outline,
                                ),
                                onPressed: () {
                                  _onButtonClick(url);
                                },
                                child: _storageResult == null || _storageResult!.isDownloadInProgress
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          value: _downloadPrecent <= 0 ? null : _downloadPrecent,
                                        ),
                                      )
                                    : const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("Download full syllabus"),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void launchUrlsyllabus(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url.toString(), mode: LaunchMode.externalApplication);
    } else
      throw "Could not launch url";
  }

  void _onButtonClick(String url) async {
    showSnackBar(context, "Downloading Syllabus ");
    if (_storageResult!.path != null) {
      OpenFile.open(_storageResult!.path!, type: _storageResult!.type);
      return;
    }
    _storageResult = _storageResult!.updateDownloadStatus(status: true);
    _storage.downloadFile(
      result: _storageResult!,
      progress: (percentage, path) {
        setState(() {
          _downloadPrecent = percentage;
          if (_downloadPrecent == 1.0)
            _storageResult = _storageResult!.updateDownloadStatus(
              status: false,
              path: path,
            );
        });
      },
    );
    if (_storageResult!.path != null) {
      OpenFile.open(_storageResult!.path!, type: _storageResult!.type);
      return;
    }
    launchUrlsyllabus(url);
  }

  Widget _buildSubjects(String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
        ),
        const SizedBox(width: 3),
        Flexible(child: Text(name, style: TextStyle(color: Colors.white))),
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
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(20),
          child: Text(
            "Sem\n$sem",
            textAlign: TextAlign.center,
            style: isSelected
                ? const TextStyle(color: Colors.black)
                : TextStyle(
                    color: Colors.grey,
                  ),
          ),
        ));
  }
}
