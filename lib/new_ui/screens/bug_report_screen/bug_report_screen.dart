import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/screens/bug_report_screen/widgets/image_card.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/bug_report_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/image_pick.dart';

class BugReportScreen extends ConsumerStatefulWidget {
  const BugReportScreen({super.key});

  @override
  ConsumerState<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends ConsumerState<BugReportScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  List<File> images = [];

  void removeImage(File file) {
    setState(() {
      images.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool iseEnabled = false;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            toolbarHeight: 80,
            title: Text(
              'Bug Report',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 22, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Please provide a title for the bug report. This will help us identify the issue faster.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  // Add the form here
                  TextFormField(
                    maxLines: 1,
                    readOnly: iseEnabled,
                    minLines: 1,
                    decoration: const InputDecoration(
                        hintText: 'Bug title',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        isDense: true),
                    controller: titleController,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Please provide a detailed description of the bug. This will help us understand the issue better. Provide steps to reproduce the bug if possible.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    readOnly: iseEnabled,
                    maxLines: null,
                    minLines: 4,
                    decoration: const InputDecoration(
                        hintText: 'Bug description',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        isDense: true),
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  // Add the image picker here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          if (ref.read(userModelProvider) != null) {
                            if (images.length >= 4) {
                              showSnackBar(
                                  context, 'Maximum 4 images can be added.');
                              return;
                            }
                            var selected = await pickMultipleImages();
                            int canAccept = 4 - images.length;
                            if (selected.length <= canAccept) {
                              images.addAll(selected);
                            } else {
                              images.addAll(selected.sublist(0, canAccept));
                              var isSingular = false;
                              if (canAccept == 1) {
                                isSingular = true;
                              }
                              showSnackBar(context,
                                  'Only $canAccept image${isSingular ? ' is' : 's are'} added!');
                            }
                            setState(() {
                              //print(images.isEmpty);
                            });
                          } else {
                            showSnackBar(
                                context, 'You need to login to attach images.');
                          }
                        },
                        child: Text(
                          'Pick images',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (images.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Container(color: Colors.white, height: 20, width: 20,)
                          SizedBox(
                            height: 120,
                            //width: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return ImageCard(
                                  image: images[index],
                                  remImg: removeImage,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  //else const SizedBox(height: 20,),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          if (titleController.text.isEmpty ||
                              descriptionController.text.isEmpty) {
                            showSnackBar(context, 'Please fill all fields');
                            return;
                          } else {
                            showSnackBar(context, 'Submitting...');
                            String titleText = titleController.text;
                            String descriptionText = descriptionController.text;
                            setState(() {
                              iseEnabled = true;
                            });
                            if (ref.read(userModelProvider) != null) {
                              await ref
                                  .read(bugreportNotifierProvider.notifier)
                                  .addBugreport(
                                      titleText,
                                      descriptionText,
                                      images,
                                      ref
                                          .read(firebaseAuthProvider)
                                          .currentUser!
                                          .uid);
                            } else {
                              await ref
                                  .read(bugreportNotifierProvider.notifier)
                                  .addBugreport(
                                      titleText, descriptionText, images, null);
                            }
                            titleController.clear();
                            descriptionController.clear();
                            setState(() {
                              images.clear();
                              //iseEnabled = false;
                            });
                            showSnackBar(context, 'Submitted successfully');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Submit",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
