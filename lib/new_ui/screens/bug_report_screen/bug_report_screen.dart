import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/screens/bug_report_screen/widgets/image_card.dart';
import 'package:tsec_app/provider/bug_report_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/image_pick.dart';

class BugReportScreen extends ConsumerStatefulWidget {
  BugReportScreen({Key? key}) : super(key: key);
  
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
    return Scaffold(
      appBar:  AppBar(shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: Text('Bug Report',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontSize: 15, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.fade,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Please provide a title for the bug report. This will help us identify the issue faster.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 20),
              // Add the form here
              TextFormField(
                //maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                    hintText: 'Bug title',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    isDense: true),
                controller: titleController,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              const Text(
                "Please provide a detailed description of the bug. This will help us understand the issue better. Provide steps to reproduce the bug if possible.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: null,
                minLines: 1,
                decoration: const InputDecoration(
                    hintText: 'Bug description',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    isDense: true),
                controller: descriptionController,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              // Add the image picker here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: () async{
                    var selected = await pickMultipleImages();
                    images.addAll(selected);
                    setState(() {
                      //print(images.isEmpty);
                    });
                    }, child: Text('Pick images'))
                ],
              ),
              const SizedBox(height: 10),
              if (!images.isEmpty)
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
                            return ImageCard(image: images[index], remImg: removeImage,);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              //else const SizedBox(height: 20,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(onPressed: ()async{
                    if(titleController.text.isEmpty || descriptionController.text.isEmpty || images.isEmpty){
                      showSnackBar(context, 'Please fill all fields');
                      return;
                    }
                    else {
                    showSnackBar(context, 'Submitting...');
                    await ref.read(bugreportNotifierProvider.notifier).addBugreport(titleController.text, descriptionController.text, images, ref.read(firebaseAuthProvider).currentUser!.uid);
                    titleController.clear();
                    descriptionController.clear();
                    images.clear();
                    showSnackBar(context, 'Submitted successfully'); }
                  }, color: Colors.green, child: Text('Submit'),),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}