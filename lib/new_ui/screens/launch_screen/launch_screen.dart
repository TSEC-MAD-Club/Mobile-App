import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:bcrypt/bcrypt.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/Maintainance_Screen/maintainance_screen.dart';
// import 'package:tsec_app/new_ui/screens/login_screen/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  int unlocked = 0;
  Timer? _timer;
  Duration _duration = Duration();
  DateTime? _launchDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLaunchDate();
  }

  Future<void> _fetchLaunchDate() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Launch')
          .doc('launch')
          .get();
      final int unlockedData = snapshot.data()?['unlocked'] as int;
      Timestamp? timestamp = snapshot.data()?['date'] as Timestamp?;
      setState(() {
        unlocked = unlockedData;
        _launchDate = timestamp?.toDate();
        if (_launchDate != null) {
          _startTimer();
        }
      });
    } catch (e) {
      print('Error fetching launch date: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (_launchDate != null) {
        setState(() {
          _duration = _launchDate!.difference(DateTime.now());
          if (_duration.inMilliseconds <= 0) {
            _timer?.cancel();
            _navigateToLogin();
          }
        });
      }
    });
  }

  void _navigateToLogin() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('Launch')
        .doc('launch')
        .get();
    int unlockedData = snapshot.data()!["unlocked"];
    Map<String,dynamic> map = {
      "unlocked": unlockedData
    };
    await FirebaseFirestore.instance.collection("Launch").doc('launch').update(map);

    // Launch URL
    const url = 'https://tsecdevsclub.com/launchForm';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

    context.go('/login');
  }

  Future<void> _checkAnswer() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Launch')
          .doc('launch')
          .get();
      String hashedAnswer = snapshot.data()?['ans'] ?? '';

      // Compare the hashed answer with the user input
      if (BCrypt.checkpw(_controller.text.trim(), hashedAnswer)) {
        _navigateToLogin();
      } else {
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect code. Please try again.')),
        );
      }
    } catch (e) {
      print('Error checking answer: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int days = _duration.inDays;
    final int hours = _duration.inHours % 24;
    final int minutes = _duration.inMinutes % 60;
    final int seconds = _duration.inSeconds % 60;
    final int milliseconds = _duration.inMilliseconds % 1000;

    return Scaffold(
      backgroundColor: commonbgblack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            // Row(
            //   children: [
            //     Spacer(),
            //     SizedBox(
            //       height: 10,
            //     ),
            //     Text("Student's Unlocked: $unlocked",style: TextStyle(
            //       color: Colors.grey[600],
            //       fontSize: 10,
            //     ),),
            //     SizedBox(
            //       width: 15,
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 60,
            ),
            Image.asset(
              'assets/images/devs-dark.png',
              height: 250,
              width: 250,
            ),
            Text(
              "App Launch in",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              _launchDate == null
                  ? 'Loading...'
                  : '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),
            Text(
              r'$2a$10$2FYV.6fyPfD4mO7arFVI3eUC.98haCmPBgSmO21IV6.nYbByoW2Ii',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 8,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: commonbgLightblack,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: commonbgLightblack,
                      width: 1.5,
                    ),
                  ),
                  hintText: 'Code for pre access',
                  hintStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  _checkAnswer();
                },
              ),
            ),
            SizedBox(height: 30),
            Center(),
            SizedBox(
              height: 10,
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () async {
                const url = 'https://tsecdevsclub.com/launchDashboard';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text(
                "Student's Unlocked: $unlocked",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}
