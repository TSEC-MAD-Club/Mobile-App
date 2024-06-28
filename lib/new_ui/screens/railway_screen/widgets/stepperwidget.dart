import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class StatusStepper extends StatelessWidget {
  final String concessionStatus;

  StatusStepper({required this.concessionStatus});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      width: size.width * 0.9,
      child: EasyStepper(
        finishedStepBorderColor: Colors.blue,

        lineStyle: LineStyle(
            lineLength: size.width * 0.2,
            finishedLineColor: Colors.blue,
            lineType: LineType.normal,
            unreachedLineColor: Colors.grey.shade600,
            unreachedLineType: LineType.dotted,
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
    if(concessionStatus == "serviced" || concessionStatus == "rejected") {return 2;}
    else if(concessionStatus == "unserviced") {return 1;}
    else {return 0;}
  }
}
