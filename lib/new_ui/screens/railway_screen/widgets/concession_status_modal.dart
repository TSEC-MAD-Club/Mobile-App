import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/utils/railway_enum.dart';

class ConcessionStatusModal extends ConsumerStatefulWidget {
  Function canIssuePass;
  // ConcessionDetailsModel? concessionDetails;
  // DateTime? lastPassIssued;
  // String? duration;
  Function futurePassMessage;

  ConcessionStatusModal(
      {super.key, required this.canIssuePass,
      // required this.concessionDetails, required this.lastPassIssued,
      // required this.duration,
      required this.futurePassMessage});

  @override
  ConsumerState<ConcessionStatusModal> createState() =>
      _ConcessionStatusModalState();
}

class _ConcessionStatusModalState extends ConsumerState<ConcessionStatusModal> {
  @override
  Widget build(BuildContext context) {
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);
    DateTime? lastPassIssued = concessionDetails?.lastPassIssued;
    String? duration = concessionDetails?.duration;
    // debugPrint(concessionDetails?.status);
    // debugPrint(
    //     widget.canIssuePass(concessionDetails, lastPassIssued, duration).toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 70,
        decoration: BoxDecoration(
          color: concessionDetails?.status == ConcessionStatus.rejected
              ? Theme.of(context).colorScheme.error
              : widget.canIssuePass(concessionDetails, lastPassIssued, duration)
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          // boxShadow: isItDarkMode
          //     ? shadowLightModeTextFields
          //     : shadowDarkModeTextFields,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    concessionDetails?.status == ConcessionStatus.rejected
                        ? "Rejected"
                        : concessionDetails?.status ==
                                ConcessionStatus.unserviced
                            ? "Pending"
                            : widget.canIssuePass(
                                    concessionDetails, lastPassIssued, duration)
                                ? "Can apply"
                                : "",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              Text(concessionDetails?.status == ConcessionStatus.rejected
                  ? concessionDetails!.statusMessage
                  : widget.canIssuePass(
                          concessionDetails, lastPassIssued, duration)
                      ? "Apply for a new pass"
                      : (concessionDetails?.status ==
                                  ConcessionStatus.serviced ||
                              concessionDetails?.status ==
                                  ConcessionStatus.downloaded)
                          ? widget.futurePassMessage()
                          : concessionDetails!.statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
