import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/services/concession_service.dart';
import 'package:tsec_app/utils/notification_type.dart';

final concessionDetailsProvider = StateProvider<ConcessionDetailsModel?>((ref) {
  return null;
});

final concessionProvider =
    StateNotifierProvider<ConcessionProvider, bool>(((ref) {
  return ConcessionProvider(
      ref: ref, concessionService: ref.watch(concessionServiceProvider));
}));

// final studentModelProvider = StateProvider<StudentModel?>((ref) {
//   return null;
// });

// final profilePicProvider = StateProvider<Uint8List?>((ref) {
//   return null;
// });

// final userProvider = StateProvider<User?>((ref) {
//   return ref.watch(authServiceProvider).user;
// });

class ConcessionProvider extends StateNotifier<bool> {
  final ConcessionService _concessionService;

  final Ref _ref;

  ConcessionProvider({concessionService, ref})
      : _concessionService = concessionService,
        _ref = ref,
        super(false);

  Future applyConcession(ConcessionDetailsModel concessionDetails,
      File idCardPhoto, File previousPassPhoto, BuildContext context) async {
    ConcessionDetailsModel concessionDetailsData = await _concessionService
        .applyConcession(concessionDetails, idCardPhoto, previousPassPhoto);

    _ref.read(concessionDetailsProvider.notifier).state = concessionDetailsData;
  }

  Future getConcessionData() async {
    ConcessionDetailsModel? concessionDetailsData =
        await _concessionService.getConcessionDetails();
    // debugPrint("concession: ${concessionDetailsData?.firstName}");
    _ref.read(concessionDetailsProvider.notifier).state = concessionDetailsData;
  }

  // Future<UserCredential?> signInUser(
  //     String email, String password, BuildContext context) async {
  //   return await _concessionService.signInUser(email, password, context);
  // }

  // Future resetPassword(String email, BuildContext context) async {
  //   return await _concessionService.resetPassword(email, context);
  // }

  // Future updateProfilePic(Uint8List image) async {
  //   _ref.read(profilePicProvider.notifier).state = image;
  //   await _concessionService.updateProfilePic(image);
  // }

  // Future fetchProfilePic() async {
  //   final user = _ref.read(firebaseAuthProvider).currentUser;
  //   String url =
  //       "https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/Images%2F${user?.uid}";
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final jsonResponse =
  //         Map<String, dynamic>.from(json.decode(response.body));
  //     // return jsonResponse['downloadTokens'] ?? '';
  //     url = "$url?alt=media&token=${jsonResponse['downloadTokens']}";
  //     final res = await http.get(Uri.parse(url));
  //     if (res.statusCode == 200) {
  //       _ref.read(profilePicProvider.notifier).state = res.bodyBytes;
  //       debugPrint("download url in auth provider is $url");
  //       return response.bodyBytes;
  //     } else {
  //       throw Exception('Failed to fetch image');
  //     }
  //   } else {
  //     _ref.read(profilePicProvider.notifier).state = null;
  //   }
  // }

  // Future<StudentModel?> fetchStudentDetails(
  //     User? user, BuildContext context) async {
  //   return await _concessionService.fetchStudentDetails(user, context);
  // }

  // void changePassword(String password, BuildContext context) {
  //   _concessionService.updatePassword(password, context);
  // }

  // Future updateUserStateDetails(
  //     StudentModel? studentmodel, WidgetRef ref) async {
  //   if (studentmodel != null) {
  //     String studentYear = studentmodel.gradyear.toString();
  //     String studentBranch = studentmodel.branch.toString();
  //     String studentDiv = studentmodel.div.toString();
  //     String studentBatch = studentmodel.batch.toString();

  //     ref.read(notificationTypeProvider.notifier).state = NotificationTypeC(
  //         notification: "All",
  //         yearTopic: studentYear,
  //         yearBranchTopic: "$studentYear-$studentBranch",
  //         yearBranchDivTopic: "$studentYear-$studentBranch-$studentDiv",
  //         yearBranchDivBatchTopic:
  //             "$studentYear-$studentBranch-$studentDiv-$studentBatch");
  //   }
  // }

  // Future updateUserDetails(
  //     StudentModel student, WidgetRef ref, BuildContext context) async {
  //   try {
  //     StudentModel updatedStudentData =
  //         await _concessionService.updateUserDetails(student);
  //     _ref.read(studentModelProvider.notifier).state = updatedStudentData;

  //     // StudentModel? data = ref.watch(studentModelProvider);
  //     // if (data != null) NotificationType.makeTopic(_ref);

  //     StudentModel? studentmodel = ref.watch(studentModelProvider);
  //     NotificationType.makeTopic(ref, studentmodel);
  //     updateUserStateDetails(studentmodel, ref);
  //     // String studentYear = updatedStudentData.gradyear.toString();
  //     // String studentBranch = updatedStudentData.branch.toString();
  //     // String studentDiv = updatedStudentData.div.toString();
  //     // String studentBatch = updatedStudentData.batch.toString();
  //     // yearTopic = studentYear;
  //     // yearBranchTopic = "$studentYear-$studentBranch";
  //     // yearBranchDivTopic = "$studentYear-$studentBranch-$studentDiv";
  //     // yearBranchDivBatchTopic =
  //     //     "$studentYear-$studentBranch-$studentDiv-$studentBatch";

  //     // ref.read(notificationTypeProvider.notifier).state = NotificationTypeC(
  //     //     notification: "All",
  //     //     yearTopic: studentYear,
  //     //     yearBranchTopic: "$studentYear-$studentBranch",
  //     //     yearBranchDivTopic: "$studentYear-$studentBranch-$studentDiv",
  //     //     yearBranchDivBatchTopic:
  //     //         "$studentYear-$studentBranch-$studentDiv-$studentBatch");

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text(studentmodel?.updateCount! == 1
  //               ? 'Profile updated successfully. You are only allowed to update it once again '
  //               : "Profile updated successfully. You have already updated it as many times as possible ")),
  //     );
  //   } catch (e) {
  //     print('Error updating profile: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('An error occurred. Please try again later.')),
  //     );
  //   }
  // }

  // Future signout() async {
  //   await _concessionService.signout();
  // }
}
