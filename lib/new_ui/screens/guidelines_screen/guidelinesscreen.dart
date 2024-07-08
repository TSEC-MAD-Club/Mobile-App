import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/guidelines_screen/widgets/FAQCard.dart';

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
  }

  setGuidelines() {
    FirebaseFirestore.instance
        .collection("Guidelines")
        .doc("Guidelines")
        .get()
        .then((value) {
      setState(() {
        faqs = value.data()!['faqs'];
        guideLines = value.data()!['guidelines'];
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
                  Container(
                    width: size.width * 0.85,
                    child: Text(
                      "Guidelines",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
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
                      if (guideline.containsKey("text")) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            "- This would be a point from the Guidelines therefore Tryign to make it long so that it could be checked for overflow",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.1, vertical: 20),
                          height: size.height * 0.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(guideline['image']),
                                fit: BoxFit.fill),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    width: size.width * 0.85,
                    child: Text(
                      "FAQ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: faqs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map<String,dynamic> faq = faqs[index];
                        return FAQCard(faqContent: faq["content"],faqTitle: faq["title"],);
                      }),
                  SizedBox(
                    height: size.height * 0.03,
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

class ViewImage extends StatelessWidget {
  final int index;

  ViewImage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "pic$index",
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://i.pinimg.com/564x/98/24/71/982471c8a222007297475323a0c4f5f9.jpg"),
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
      ),
    );
  }
}
