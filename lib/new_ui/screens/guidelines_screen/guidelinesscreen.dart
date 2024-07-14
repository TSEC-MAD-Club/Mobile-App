import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/guidelines_screen/widgets/FAQCard.dart';
import 'package:tsec_app/new_ui/screens/guidelines_screen/widgets/guidelines_card.dart';
import 'package:tsec_app/services/localnotificationservice.dart';

class GuideLinesScreen extends StatefulWidget {
  @override
  State<GuideLinesScreen> createState() => _GuideLinesScreenState();
}

class _GuideLinesScreenState extends State<GuideLinesScreen> {
  List guideLines = [];
  List faqs = [];

  @override
  void initState() {
    super.initState();
    setGuidelines();
    setFAQ();
  }

  setGuidelines() {
    FirebaseFirestore.instance
        .collection("ConcessionGuidelines")
        .doc("guideLines")
        .get()
        .then((value) {
      setState(() {
        guideLines = value.data()!['guideLines'];
      });
    });
  }

  setFAQ() {
    FirebaseFirestore.instance
        .collection("ConcessionGuidelines")
        .doc("faq")
        .get()
        .then((value) {
      setState(() {
        faqs = value.data()!['faq'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: guideLines.isNotEmpty && faqs.isNotEmpty
          ? SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.75,
                  child: Text(
                    "Railway Guidelines",
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 27,
                      shadows: [Shadow(offset: Offset(1.0, 1.0),blurRadius: 3.0,color: Colors.blue,),],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "FAQ",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20,
                              shadows: [Shadow(offset: Offset(1.0, 1.0),blurRadius: 3.0,color: Colors.blue,),
                              ],
                            ),
                          ),
                          content: Container(
                            width: double.maxFinite,
                            height: 400,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: faqs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> faq = faqs[index];
                                return FAQCard(
                                  faqContent: faq["content"],
                                  faqTitle: faq["title"],
                                );
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                "Close",
                                style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: guideLines.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map<String, dynamic> guideline = guideLines[index];
                return GuidelinesCard(inputGuideline: guideline);
              },
            ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
