import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "TSEC App",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 15.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/images/devs.png',
                    width: MediaQuery.of(context).size.width * 0.75,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: "Welcome to the official app of the Thadomal Shahani Engineering College (TSEC), developed by the dedicated members of the Developers Club. Our app is designed to enhance your academic experience and streamline your access to important college information. Here’s a brief overview of the key features:\n\n",
                    ),
                    TextSpan(
                      text: "1. Timetable\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Access your class-wise timetable customized for your specific batch and class. Stay organized and never miss a class.\n\n",
                    ),
                    TextSpan(
                      text: "2. Notes\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Teachers can upload lecture notes and study materials directly to the app. Students can easily view and download these notes for their studies.\n\n",
                    ),
                    TextSpan(
                      text: "3. Railway Concession\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Simplify the process of requesting railway concessions. Submit your requests through the app and receive notifications when they are approved.\n\n",
                    ),
                    TextSpan(
                      text: "4. Department Section\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Find detailed information about every department within TSEC, including faculty details and curriculum. Access PDFs of syllabuses to stay informed about your course structure.\n\n",
                    ),
                    TextSpan(
                      text: "5. Committees\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Learn about the various committees in the college. Get involved and stay updated on their activities and initiatives.\n\n",
                    ),
                    TextSpan(
                      text: "6. Events\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Keep track of all the events happening in college. From seminars to cultural fests, never miss an opportunity to participate.\n\n",
                    ),
                    TextSpan(
                      text: "7. Notifications\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Receive important notifications from faculty regarding timetable changes, announcements, and event updates. Stay informed about the status of your railway concession requests.\n\n",
                    ),
                    TextSpan(
                      text: "This app is crafted with the needs of TSEC students in mind, aiming to provide a seamless and efficient way to manage your academic and extracurricular activities. We hope you find it useful and we look forward to your feedback to make it even better.\n\n",
                    ),
                    TextSpan(
                      text: "Developers Club of TSEC",
                      style: TextStyle(fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 15.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}