// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_edit_modal.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_screen_appbar.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RailWayConcession extends ConsumerStatefulWidget {
  const RailWayConcession({super.key});

  @override
  ConsumerState<RailWayConcession> createState() => _RailWayConcessionState();
}

class _RailWayConcessionState extends ConsumerState<RailWayConcession> {
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();

  bool _iscomplete = false;
  bool _isfilled = true;
  String? status;
  String? statusMessage;
  String? duration;
  DateTime? lastPassIssued;

  bool canIssuePass(DateTime lastPassIssued, String duration) {
    DateTime today = DateTime.now();
    DateTime lastPass = lastPassIssued;
    int diff = today.difference(lastPass).inDays;
    bool retVal = (duration == "Monthly" && diff >= 30) ||
        (duration == "Quarterly" && diff >= 90);
    // debugPrint(retVal.toString());
    // debugPrint(status);
    return retVal;
  }

  String futurePassMessage() {
    DateTime today = DateTime.now();
    DateTime lastPass = lastPassIssued ?? DateTime.now();
    DateTime futurePass = lastPass.add(
        duration == "Monthly" ? const Duration(days: 30) : Duration(days: 90));
    int diff = futurePass.difference(today).inDays;
    return "You will be able to apply for a new pass after $diff days";
  }

  void fetchData() {
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);

    status = concessionDetails?.status ?? "";
    statusMessage = concessionDetails?.statusMessage ?? "";
    lastPassIssued = concessionDetails?.lastPassIssued ?? DateTime.now();
    duration = concessionDetails?.duration ?? "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchData();
    if (status == "rejected") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 7000),
            content: Text(
                "Your concession service request has been rejected: $statusMessage")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return CustomScaffold(
      hideButton: !_isfilled || _iscomplete,
      appBar: const RailwayAppBar(title: "Railway Concession"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // controller: listScrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/railwayConcession.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // _iscomplete
                            //     ? const Text("")
                            //     : Text(
                            //         "Please fill the form",
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .headlineMedium
                            //             ?.copyWith(fontWeight: FontWeight.w600),
                            //       )
                          ],
                        ),
                        status == "" ||
                                status == "rejected" ||
                                canIssuePass(lastPassIssued ?? DateTime.now(),
                                    duration ?? "Monthly")
                            ? RailwayEditModal(
                                isfilled: _isfilled,
                                setIsFilled: (val) =>
                                    setState(() => _isfilled = val),
                                setIsComplete: (val) =>
                                    setState(() => _iscomplete = val),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  status == "unserviced" ||
                          ((status == "downloaded" || status == "serviced") &&
                              !canIssuePass(lastPassIssued ?? DateTime.now(),
                                  duration ?? "Monthly"))
                      ? Align(
                          alignment: Alignment.center,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                                child: OverflowBox(
                                  minHeight: 200,
                                  maxHeight: 200,
                                  child: Lottie.network(
                                    'https://lottie.host/4587f75c-712e-4f2f-b41e-a142550cf0e1/vxuqbtWnpV.json',
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: status == "unserviced"
                                    ? Text(
                                        'Form is Submitted Successfully. $statusMessage')
                                    : status == "serviced" ||
                                            status == "downloaded"
                                        ? Text(futurePassMessage())
                                        : Container(),
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
