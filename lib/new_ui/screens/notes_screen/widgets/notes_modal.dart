import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class NotesModal extends StatefulWidget {
  Function action;
  NotesModal({super.key, required this.action});

  @override
  State<NotesModal> createState() => _NotesModalState();
}

class _NotesModalState extends State<NotesModal> {
  FilePickerResult? selectedFiles;

  Future<void> pickFiles() async { FilePickerResult? results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );

    if (results != null) {
      setState(() {
        selectedFiles = results;
      });
    } else {
      // User canceled the picker
    }
  }

  void deselectFile(PlatformFile file) {
    setState(() {
      selectedFiles!.files.remove(file);
    });
  }

  void openFile(String? filePath) {
    if (filePath != null) {
      OpenFile.open(filePath);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.background,
      ),
      width: MediaQuery.of(context).size.width * 0.90,
      height: MediaQuery.of(context).size.height * 0.70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Subject",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.3,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 14),
            child: const TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                labelText: "Title",
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.3,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            padding: const EdgeInsets.all(8.0).copyWith(left: 14),
            child: const TextField(
              maxLines: 7,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                labelText: "Description",
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.3,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attachments',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: selectedFiles?.files.length ?? 0,
                    itemBuilder: (context, index) {
                      var file = selectedFiles!.files[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 2.0),
                        child: GestureDetector(
                          onTap: () => openFile(file.path),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  file.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => deselectFile(file),
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     CustomPdfIcon(
                //       pdfName: "module_5.pdf",
                //     ),
                //     SizedBox(
                //       width: 8,
                //     ),
                //     CustomPdfIcon(
                //       pdfName: "module_6.pdf",
                //     ),
                //   ],
                // )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 40,
                  left: 30,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await pickFiles();
                    },
                    child: const Text('Attach'),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  // onPressed: () {
                  //
                  //   setState(() {
                  //     _dialogVisible = false;
                  //   });
                  // },
                  onPressed: () {
                    widget.action.call();
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color:
                        // Theme.of(context).colorScheme.onSecondaryContainer,
                        Colors.green.shade400,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Firebase uploading logic
              },
              child: const Text('Upload'),
            ),
          ),
        ],
        )
      ,
    );
  }
}
