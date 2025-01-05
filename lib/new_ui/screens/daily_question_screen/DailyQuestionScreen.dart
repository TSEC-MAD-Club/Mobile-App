import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DailyQuestionScreen extends StatefulWidget {
  const DailyQuestionScreen({super.key});

  @override
  State<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  Map<String, dynamic>? question;
  final questionCollection = FirebaseFirestore.instance.collection("Questions");

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  getQuestion() async {
    final get = await questionCollection.doc("3QKaQ5ENeMqYrFxIAzZk").get();
    setState(() {
      question = get.data();
    });
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    print(question);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: Text(
          'Questions',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontSize: 15, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: question == null
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    width: size.width * 0.8,
                    child: Row(
                      children: [
                        Text(
                          "Question",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          question!['topic'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 0.85,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade300,
                      ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Text(
                      question!['question'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      width: size.width * 0.85,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: index == 1 ? Colors.blue : null,
                        border: Border.all(
                          color: Colors.blue.shade300,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: index == 1 ? Colors.black : Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            question!['option1'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      width: size.width * 0.85,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: index == 2 ? Colors.blue : null,
                        border: Border.all(
                          color: Colors.blue.shade300,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: index == 2 ? Colors.black : Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            question!['option2'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 3;
                      });
                    },
                    child: Container(
                      width: size.width * 0.85,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: index == 3 ? Colors.blue : null,
                        border: Border.all(
                          color: Colors.blue.shade300,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: index == 3 ? Colors.black : Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            question!['option3'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 4;
                      });
                    },
                    child: Container(
                      width: size.width * 0.85,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: index == 4 ? Colors.blue : null,
                        border: Border.all(
                          color: Colors.blue.shade300,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: index == 4 ? Colors.black : Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            question!['option4'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.blue,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            question!['hint'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Want a Hint",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.question_mark,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    width: size.width * 0.85,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
      ),
    );
  }
}
