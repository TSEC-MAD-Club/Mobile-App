import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/guidelines_screen/widgets/FAQCard.dart';
import 'package:tsec_app/new_ui/screens/guidelines_screen/widgets/guidelines_card.dart';

class GuideLinesScreen extends StatefulWidget {
  @override
  State<GuideLinesScreen> createState() => _GuideLinesScreenState();
}

class _GuideLinesScreenState extends State<GuideLinesScreen> {

  final Map<String,dynamic> uploadMap = {

    "guideLines": [
          {
            "title": "First Time Applying for Railway Concession?",
            "content": "If you've never applied for a railway concession pass, please visit the Railway Concession Desk on the ground floor of the new building."
          },
          {
            "title": "First Time Using the TSEC App for Railway Concession and Have previous pass?",
            "content": "If you're using the app for the first time and have your previous pass, follow these four easy steps:",
            "points": [
              "1. Apply Online using our app.", "2. Wait for your pass to be approved.", "3. Receive a notification once approved.", "4. Collect your pass from the Railway Concession Desk (Ground floor, new building)."
            ]
          },
          {
            "title": "Detailed Guide",
            "content": [
              {
                "subtitle": "Step I: Submit Your Online Application",
                "subPoints": [
                  {
                    "words": "1. Open the TSEC App."
                  },
                  {
                    "words": "2. Navigate to the Railway Concession feature."
                  },
                  {
                    "image": "https://(<bottomAppBarCircled>)"
                  },
                  {
                    "words": "3. Tap the Apply button ."
                  },
                  {
                    "image": "https://(<applyButton>)"
                  },
                  {
                    "words": "4. Fill in the required details on the form "
                  },
                  {
                    "image": "https://(<railwayFormSS>)."
                  },
                  {
                    "words": "NOTE: Ensure accuracy, as discrepancies can lead to rejection"
                  },
                  {
                    "words": "5. Upload a clear photo of the front and back of your ID Card"
                  },
                  {
                    "image": "https://(<IDCardSectionSS>)."
                  },
                  {
                    "words": "6. Upload an image of your previous pass."
                  },
                  {
                    "image": "https://(<previousPassImage>)."
                  },
                  {
                    "words": "NOTE: If you don't have a previous pass or ID card, visit the Railway Concession Desk (Ground floor, new building)."
                  },
                  {
                    "words": "7. Submit the form. It may take a few seconds to process"
                  },
                  {
                    "words": "NOTE: Once submitted, you will see the following changes: "
                  },
                  {
                    "image": "https://<imageAfterFormFilled>."
                  }
                ]
              },
              {
                "subtitle": "Step II: Wait for Approval",
                "subPoints": [
                  {
                    "words": "1. The approval process may take a day or so. Apply before your current pass expires to avoid delays."
                  },
                  {
                    "words": "2. Upon approval, you will receive a notification."
                  },
                  {
                    "image": "https://(<notificationSS>)."
                  },
                  {
                    "words": "To modify your application or extend dates, visit the Railway Concession Desk (Ground floor, new building)."
                  }
                ]
              },
              {
                "subtitle": "Step III: Concession Approval",
                "subPoints": [
                  {
                    "words":  "1. Once approved, you'll receive a notification and a pass number, displayed on the railway concession screen"
                  },
                  {
                    "image": "https://(<approveScreenSS>)."
                  },
                  {
                    "words": "2. Show this pass number to collect your railway slip from the Railway Concession Desk (Ground floor, new building)."
                  }
                ]
              },
              {
                "subtitle": "Step IV: Collecting Your Railway Concession",
                "subPoints": [
                  {
                    "words": "1. Show your pass number to collect the slip. You will receive a notification as an acknowledgment"
                  },
                  {
                    "image": "https://(<notificationSS>)."
                  },
                  {
                    "words": "Your interface will update as follows after collection:"
                  },
                  {
                    "image": "https://<collectedScreenSS>."
                  }
                ]
              },
              {
                "subtitle": "After Collecting the Pass",
                "subPoints": [
                  {
                    "words": "You will receive a reminder notification 3 days before your pass expires, prompting you to apply for a new pass. For example, if your pass is issued on July 6th and expires on August 5th, you can apply for a new pass from August 2nd. Reminders will be sent accordingly"
                  },
                  {
                    "image": "https://(<notificationOfReminders>)."
                  }
                ]
              }
            ]
          },
          {
            "title": "Used the TSEC App Before?",
            "content": "Great! If you've used the TSEC App for railway concession before, it's even easier. Just open the app, update your previous pass photo, and you're done!",
            "points": [
              "https://<updatePhotoSS>"
            ]
          }
        ],
    "faq": [
          {
            "title": "I have never applied concession",
            "content": "Visit Railway Concession Desk on the ground floor of the new building."
          },
          {
            "title": "I have never used TSEC App have applied for concesion earlier in offline mode",
            "content": "Great ! you might be having your previous pass. Upload ots photo in the form and follow the guidelines"
          },
          {
            "title": "I have lost my previous pass OR dont have ID Card",
            "content": "Visit Railway Concession Desk on the ground floor of the new building."
          },
          {
            "title": "I am FE, Can I apply ?",
            "content": "Ofcouse you can, but offline untill you dont get your login credentials of TSEC App"
          },
          {
            "title": "I have applied, didnt receive approval yet but have filled my data wrong on App, what to do ?",
            "content": "No worries, you can still Visit Railway Concession Desk on the ground floor of the new building, give your details as NAME and YEAR. Your issue will be resolved and a confirmation notification will be sent to you on the spot"
          },
          {
            "title": "I have applied, received approval but have filled my data wrong on App, what to do ?",
            "content": "No worries, you can still Visit Railway Concession Desk on the ground floor of the new building, give the pass number displayed on Railway Concession Screen. Your issue will be resolved and a confirmation notification will be sent to you on the spot"
          },
          {
            "title": "I have applied, received approval but I could not visit Railway consession Desk in college to collect slip, what to do ?",
            "content": "No worries, you can still Visit Railway Concession Desk on the ground floor of the new building, give the pass number displayed on Railway Concession Screen. Your issue will be resolved and a confirmation notification will be sent to you on the spot"
          },
          {
            "title": "I have applied, received approval, collected Railway slip but could not remove Railway pass and its been more than 3 days now, what to do ?",
            "content": "No worries, you can still Visit Railway Concession Desk on the ground floor of the new building, give the pass number displayed on Railway Concession Screen. You will be receiving a renew pass with extended date. Follow futher instructions as said by Person on desk."
          },
          {
            "title": "My pass is expiring in 3 days, what to do?",
            "content": "Since 3 days before your pass expires, you will be receiving notification reminders everyday around 7am to renew your pass. Please apply for your pass before it expires"
          },
          {
            "title": "My pass had expired today OR few days back, can I still apply?",
            "content": "Ofocurse! You can.. Follow the same procedure what you did to appky for the first time. Its easy now, just dont forget to change previous pass's photo"
          }
        ]
  };

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
            faqs = value.data()!['faq'];
            guideLines = value.data()!['guideLines'];
          });
    });
  }

  uploadMapFunction(){
    FirebaseFirestore.instance.collection('Guidelines').doc("Guidelines").set(uploadMap);
    print("Uploaded");
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
                      //print(guideLines[index]);
                      Map<String, dynamic> guideline = guideLines[index];
                      return GuidelinesCard(inputGuideline: guideline);
                      // if (guideline.containsKey("text")) {
                      //   return Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 30, vertical: 10),
                      //     child: Text(
                      //       "- ${guideline["text"]}",
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   );
                      // } else {
                      //   return Container(
                      //     margin: EdgeInsets.symmetric(
                      //         horizontal: size.width * 0.1, vertical: 20),
                      //     height: size.height * 0.2,
                      //     decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: NetworkImage(guideline['image']),
                      //           fit: BoxFit.fill),
                      //     ),
                      //   );
                      // }
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
