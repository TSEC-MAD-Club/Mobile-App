import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tsec_app/screens/notes_screen/widgets/custom_pdf_icon.dart';

class NoteList extends StatefulWidget {
  final String subject;
  final String noteTitle;
  final String date;
  final String noteContent;
  final String pdfCount;
  final String teacherName;

  const NoteList({
    super.key,
    required this.subject,
    required this.noteTitle,
    required this.date,
    required this.noteContent,
    required this.pdfCount,
    required this.teacherName,
  });

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool _isVisible = false;

  void _toggleFilterVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  /* This method is for shortening the note content 
    written for 5 words, if needed more, just change the number
  */
  String _getFirst5Words(String content) {
    List<String> words = content.split(' ');
    if (words.length > 5) {
      return '${words.sublist(0, 5).join(' ')}...';
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: _isVisible ? 10.00 : 0.00,
        sigmaY: _isVisible ? 10.00 : 0.00,
      ),
      child: AnimatedCrossFade(
        // first child is the Note which'll be shown on noteScreen
        firstChild: GestureDetector(
          onTap: _toggleFilterVisibility,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                10,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.subject,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.noteTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    /* use can use the 
                       _getFirst5Words method here if want to 
                       _getFirst5Words(widget.noteContent)
                       method on line no. 40
                    */
                    widget.noteContent,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CustomPdfIcon(pdfName: "module_6.pdf"),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            /* 
                              this the pdfCount 
                              if there are 3 pdfs then 1 will be shown in the 
                              list and the no. of rest all will be shown (+3)
                              so if there are 3 pdf's in total then it'll be +2
                              along with the one pdf in list 
                            */
                            '+${widget.pdfCount}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '- ${widget.teacherName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

        // Second child is the Note content page
        secondChild: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      widget.subject,
                      style: const TextStyle(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.noteTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  padding: const EdgeInsets.all(8.0).copyWith(left: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.noteContent,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(left: 14),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attachments',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomPdfIcon(
                            pdfName: "module_5.pdf",
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          CustomPdfIcon(
                            pdfName: "module_6.pdf",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 25,
                    top: 40,
                  ),
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                          });
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
                  ),
                ),
              ],
            ),
          ),
        ),
        crossFadeState:
            !_isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(
          seconds: 1,
        ),
      ),
    );
  }
}
