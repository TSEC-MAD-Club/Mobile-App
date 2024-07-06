import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/models/concession_request_model/concession_request_model.dart';
import 'package:tsec_app/new_ui/colors.dart';

class StatusStepper extends StatelessWidget {
  final String concessionStatus;
  final ConcessionRequestModel? concessionRequestData;

  StatusStepper({required this.concessionStatus,required this.concessionRequestData});

  @override
  Widget build(BuildContext context) {
    print("Inside Stepper ${concessionRequestData!.toJson()}");
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      width: size.width * 0.9,
      child: EasyStepper(
        enableStepTapping: false,
        finishedStepBorderColor: Colors.white,
        activeStepBorderColor: Colors.white,
        activeStepBorderType: BorderType.normal,
        finishedStepBorderType: BorderType.normal,
        finishedStepBackgroundColor: Colors.white,
        activeStepBackgroundColor: Colors.white,

        lineStyle: LineStyle(
            lineLength: size.width * 0.1,
            finishedLineColor: Colors.white,
            lineType: LineType.normal,
            unreachedLineColor: Colors.grey.shade600,
            unreachedLineType: LineType.dashed,
        ),
        showLoadingAnimation: false,
        stepRadius: 20,
        activeStep: getActiveStep(),
        activeStepTextColor: Colors.white,
        unreachedStepTextColor: Colors.grey.shade600,
        finishedStepTextColor: Colors.white,
        alignment: Alignment.center,

        steps: [
          getFirstStep(),
          getMiddleStep(),
          getFinalStep(),
          if(concessionRequestData != null)
            getCollectedStep(),
        ],
      ),
    );
  }

  getStatusCircle(int status) {
    if (status == 0) {
      //0 for Step SuccessFul
      return CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      );
    } else if (status == 1) {
      //1 for Step Pending Yellow
      return CircleAvatar(
        backgroundColor: Colors.yellow.shade800,
        child: Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
      );
    } else if (status == 2) {
      // Two for Rejected Status
      return CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
      );
    }
  }

  EasyStep getFinalStep() {
    print(concessionStatus);
    if (concessionStatus == "rejected") {
      return EasyStep(
        customStep: getStatusCircle(2),
        title: "Rejected",
      );
    } else if (concessionStatus == "serviced") {
      return EasyStep(
        customStep: getStatusCircle(0),
        title: "Approved",
      );
    }
    return EasyStep(
      customStep: getStatusCircle(-1),
      title: "Approval",
    );
  }

  EasyStep getCollectedStep() {
    if (concessionRequestData!=null && concessionRequestData?.passCollected != null ) {
      if(concessionRequestData!.passCollected!['collected'] == 1) {
        return EasyStep(
          customStep: getStatusCircle(0),
          title: "Collected",
        );
      }else{
        return EasyStep(
          customStep: getStatusCircle(1),
          title: "Not Collected",
        );
      }
    }
    return EasyStep(
      customStep: getStatusCircle(-1),
      title: "Collect",
    );
  }

  EasyStep getMiddleStep() {
    if (concessionStatus == "unserviced") {
      return EasyStep(
        customStep: getStatusCircle(1),
        title: "Under Review",
      );
    }
    else if(concessionStatus == "serviced" || concessionStatus == "rejected") {
      return EasyStep(
        customStep: getStatusCircle(0),
        title: "Reviewed",
      );
    }
    return EasyStep(
      customStep: getStatusCircle(-1),
      title: "Review",
    );
  }

  EasyStep getFirstStep() {
    if (concessionStatus == "unserviced" || concessionStatus == "rejected" || concessionStatus == "serviced") {
      return EasyStep(
        customStep: getStatusCircle(0),
        title: "Applied",
      );
    }
    return EasyStep(
      customStep: getStatusCircle(1),
      title: "Apply",
    );
  }

  int getActiveStep(){
    print(concessionRequestData!.toJson());
    if(concessionRequestData!=null && concessionRequestData?.passCollected != null && concessionRequestData!.passCollected!['collected'] == 1){
      print("Returning 3");
      return 3;
    }
    else if(concessionStatus == "serviced" || concessionStatus == "rejected") {return 2;}
    else if(concessionStatus == "unserviced") {return 1;}
    else {return 0;}
  }
}
