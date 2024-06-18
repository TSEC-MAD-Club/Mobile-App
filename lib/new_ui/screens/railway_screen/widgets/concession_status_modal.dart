import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
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
      {super.key,
      required this.canIssuePass,
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

    Size size = MediaQuery.of(context).size;

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
        alignment: Alignment.center,
        // height: 70,
        height: 50,
        width: size.width*0.7,
        decoration: BoxDecoration(
          color: concessionDetails?.status == ConcessionStatus.rejected
              ? Theme.of(context).colorScheme.error
              : widget.canIssuePass(concessionDetails, lastPassIssued, duration)
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
          // boxShadow: isItDarkMode
          //     ? shadowLightModeTextFields
          //     : shadowDarkModeTextFields,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            concessionDetails?.status != null ? "Status : ${getStatusText(concessionDetails!.status)}" : "Can Apply for Pass",
            /*"Status : ${concessionDetails?.status == ConcessionStatus.rejected
                    ? "Rejected"
          : concessionDetails?.status ==
                    ConcessionStatus.unserviced
                    ? "Pending"
          : widget.canIssuePass(
          concessionDetails, lastPassIssued, duration)
          ? "Can apply"
          : ""}",*/
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }

  String getStatusText(String status){
    if(status == ConcessionStatus.rejected){
      return "Sorry Cnncession Rejected";
    }else if(status == ConcessionStatus.unserviced){
      return "Pending";
    }else if(status == ConcessionStatus.serviced){
      return "Pass Approved";
    }
    return "You can apply for new pass";
  }
}
