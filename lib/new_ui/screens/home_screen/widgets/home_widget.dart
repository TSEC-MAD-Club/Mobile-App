import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/AnnouncementScreen/announcementscreen.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/container_icon_with_label.dart';
// import 'package:tsec_app/new_ui/screens/home_screen/widgets/expanded_card.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/event_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/widgets/card_display.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/utils/timetable_util.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String toTitleCase() {
    return this.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

class HomeWidget extends ConsumerStatefulWidget {
  Function(String page,int index) changeCurrentPage;
  HomeWidget({Key? key, required this.changeCurrentPage}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  List<EventModel> eventList = [];
  bool shouldLoop = true;
  late FirebaseMessaging _firebaseMessaging;

  void launchUrlcollege() async {
    var url = "https://tsec.edu/";

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url.toString());
    } else
      throw "Could not launch url";
  }

  void fetchEventDetails() {
    print('FetchEventData Calledd ****************************************************************************************************************************');

    ref.watch(eventListProvider).when(
        data: ((data) {
          eventList.addAll(data ?? []);
          imgList.clear();
          for (var data2 in eventList) {
            imgList.add(data2.imageUrl);
          }
          // imgList = [imgList[0]];
          if (imgList.length == 1) shouldLoop = false;
        }),

        loading: () {
          const CircularProgressIndicator();
        },
        error: (Object error, StackTrace? stackTrace) {});
  }

  var _onlyUserLoggedIn=false;
  void initState() {
    UserModel? user = ref.read(userModelProvider);
    if (user != null && user.isStudent) {
      _onlyUserLoggedIn=true;
    }
    else {
      //anonymous and faculty
      _onlyUserLoggedIn=false;
    }




    _firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    _firebaseMessaging.requestPermission();
    // Assume `userId` is the ID of the logged-in user in Firestore
    String? userId = FirebaseAuth.instance.currentUser?.uid; //<<<----------------------------------------------\
    //token generate for student
    if(_onlyUserLoggedIn && userId!=null ){


      print("**********************************************************************************************************8");
      print("logged in ");

      // Get the FCM token and save it to Firestore
      _firebaseMessaging.getToken().then((String? token) {
        assert(token != null);
        print("FCM Token: $token");
        // var recentFetchStudentData = FirebaseFirestore.instance.collection('Students ').doc(userId).get();
        //
        // print("////// ${recentFetchStudentData} //////");
        // Save the token to Firestore
        FirebaseFirestore.instance
            .collection('Students ')
            .doc(userId)
            .update({'fcmToken': token});
      });


      // Handle messages when the app is in the foreground
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print("Received a message while in the foreground!");
      //   print("Message data: ${message.data}");
      //
      //   if (message.notification != null) {
      //     print("Message also contained a notification: ${message.notification}");
      //   }
      //
      //   // Display the notification as a dialog or snackbar
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text(message.notification?.title ?? 'No Title'),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           if (message.data['imageUrl'] != null)
      //             Image.network(message.data['imageUrl']),
      //           SizedBox(height: 10),
      //           Text(
      //             message.notification?.body ?? 'No Body',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           // Add some spacing
      //         ],
      //       ),
      //     ),
      //   );
      // });

      // Handle messages when the app is in the background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message clicked!');
        // Handle the notification click event
      });

      // Get the FCM token and save it to Firestore
      _firebaseMessaging.getToken().then((String? token) {
        assert(token != null);
        print("FCM Token: $token");

        // Save the token to Firestore
        // You need to write this part to save the token in the 'Students' collection
      });

      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          print('Notification caused app to open from terminated state: ${message.data}');
          // Handle the notification click event
        }
      });



    }

    super.initState();
  }




  static List<String> imgList = [];
  final CarouselController carouselController = CarouselController();

  //static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);
  static int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    fetchEventDetails();

    final _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    UserModel? data = ref.watch(userModelProvider);
    // debugPrint("right here");
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SingleChildScrollView(
              child: Column(
                children: [
                  // if (data != null && data.isStudent) const ExpandedCard(),
                  // if (data != null && data.isStudent)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       ContainerIconWithName(
                  //         text: "Railway",
                  //         icon: Icons.directions_railway_outlined,
                  //         onPressed: () {
                  //           widget.changeCurrentPage("concession",3);
                  //         },
                  //       ),
                  //       ContainerIconWithName(
                  //         text: "Notes",
                  //         icon: Icons.menu_book_rounded,
                  //         onPressed: () {
                  //           GoRouter.of(context).push('/notes');
                  //         },
                  //       )
                  //     ],
                  //   ),


                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.rectangle,
                  //       color: _theme.colorScheme.onSecondary,
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     child: Center(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Text(
                  //               "UpComming Event",
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .headlineLarge!
                  //                   .copyWith(
                  //                       fontSize: 20,
                  //                       color: _theme.colorScheme.onPrimary),
                  //             ),
                  //           ),
                  //           CarouselSlider(
                  //             items: imgList
                  //                 .map(
                  //                   (item) => GestureDetector(
                  //                     child: Stack(
                  //                       children: [
                  //                         Padding(
                  //                           padding: const EdgeInsets.all(5.0),
                  //                           child: Container(
                  //                             decoration: BoxDecoration(
                  //                               image: DecorationImage(
                  //                                 image:
                  //                                     CachedNetworkImageProvider(
                  //                                         item),
                  //                                 fit: BoxFit.fill,
                  //                                 colorFilter: ColorFilter.mode(
                  //                                   Colors.white.withOpacity(1),
                  //                                   BlendMode.modulate,
                  //                                 ),
                  //                               ),
                  //                               color: Colors.white,
                  //                               borderRadius:
                  //                                   const BorderRadius.all(
                  //                                 Radius.circular(10),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Positioned(
                  //                           top:
                  //                               10, // Adjust this value as needed
                  //                           left:
                  //                               15, // Adjust this value as needed
                  //                           child: Container(
                  //                             decoration: BoxDecoration(
                  //                               color: _theme
                  //                                   .colorScheme.onSecondary,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10.0),
                  //                             ),
                  //                             child: Padding(
                  //                               padding:
                  //                                   const EdgeInsets.all(2.0),
                  //                               child: Text(
                  //                                 "${eventList[_currentIndex].eventDate}",
                  //                                 style: Theme.of(context)
                  //                                     .textTheme
                  //                                     .titleSmall!
                  //                                     .copyWith(
                  //                                         fontSize: 15,
                  //                                         color: _theme
                  //                                             .scaffoldBackgroundColor,
                  //                                         fontWeight:
                  //                                             FontWeight.bold),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     onTap: () {
                  //                       GoRouter.of(context).pushNamed(
                  //                           "details_page",
                  //                           queryParameters: {
                  //                             "Event Name":
                  //                                 eventList[_currentIndex]
                  //                                     .eventName,
                  //                             "Event Time":
                  //                                 eventList[_currentIndex]
                  //                                     .eventTime,
                  //                             "Event Date":
                  //                                 eventList[_currentIndex]
                  //                                     .eventDate,
                  //                             "Event decription":
                  //                                 eventList[_currentIndex]
                  //                                     .eventDescription,
                  //                             "Event registration url":
                  //                                 eventList[_currentIndex]
                  //                                     .eventRegistrationUrl,
                  //                             "Event Image Url": item,
                  //                             "Event Location":
                  //                                 eventList[_currentIndex]
                  //                                     .eventLocation,
                  //                             "Committee Name":
                  //                                 eventList[_currentIndex]
                  //                                     .committeeName,
                  //                           });
                  //                     },
                  //                   ),
                  //                 )
                  //                 .toList(),
                  //             options: CarouselOptions(
                  //               scrollPhysics: const BouncingScrollPhysics(),
                  //               autoPlay: false,
                  //               aspectRatio: 1.7,
                  //               viewportFraction: 1,
                  //               onPageChanged: (index, reason) {
                  //                 setState(() {
                  //                   _currentIndex = index;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Container(
                    margin:EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: timePickerBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: timePickerBorder, width: 1.0), // Change the color and width as needed
                    ),
                    child: Shimmer(
                      duration: Duration(seconds: 2), //Default value
                      interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                      color: Colors.blue.shade800, //Default value

                      colorOpacity: 0.6, //Default value
                      enabled: true, //Default value
                      direction: ShimmerDirection.fromLTRB(),
                      child: ListTile(
                        iconColor: Colors.grey.shade400,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AnnouncementScreen(),),),
                        title: Text("Announcement",style: TextStyle(color: Colors.white),),
                        leading: Icon(Icons.announcement,),
                        trailing: Icon(Icons.arrow_forward_ios,),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //Welcome Message
                  Container(
                      width: _size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                        child: Text(
                          "Welcome ${
                              (data != null) ?
                              data.studentModel!=null?
                              data.studentModel?.name?.toLowerCase()?.toTitleCase()
                                  :
                              data.facultyModel?.name?.toLowerCase()?.toTitleCase()
                                  :
                              "To Tsec"}",
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      )
                  ),


                  //CAROUSEL DOESNT DISPLAY WHEN LOGGED OUT,
                  //ERROR: FETCHEVENTDATA FUNCTION GETS CALLED BUT FOR SOME REASON THE IMAGES ARENT BEING FETCHED
                  CarouselSlider(
                    items: imgList
                        .map(
                          (item) => GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Container(
                              width:
                              MediaQuery.of(context).size.width * 0.6,
                              height:
                              MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(item),
                                  fit: BoxFit.fill,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white.withOpacity(1),
                                    BlendMode.modulate,
                                  ),
                                ),
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            GoRouter.of(context).pushNamed("details_page",
                                queryParameters: {
                                  "Event Name":
                                  eventList[_currentIndex].eventName,
                                  "Event Time":
                                  eventList[_currentIndex].eventTime,
                                  "Event Date":
                                  eventList[_currentIndex].eventDate,
                                  "Event decription":
                                  eventList[_currentIndex]
                                      .eventDescription,
                                  "Event registration url":
                                  eventList[_currentIndex]
                                      .eventRegistrationUrl,
                                  "Event Image Url": item,
                                  "Event Location":
                                  eventList[_currentIndex]
                                      .eventLocation,
                                  "Committee Name":
                                  eventList[_currentIndex]
                                      .committeeName
                                });
                          }),
                    )
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: shouldLoop,
                      enableInfiniteScroll: shouldLoop,
                      enlargeCenterPage: true,
                      viewportFraction: .7,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),







                  if(!_onlyUserLoggedIn)
                  //departmentlist
                    Container(
                      width: _size.width,
                      height: _size.height,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: DepartmentList(),
                      ),
                    ),



                  //CALENDER STARTS HERE

                  if(_onlyUserLoggedIn)
                    Container(
                        width: _size.width,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Text("Timetable",style: TextStyle(color: Colors.white,fontSize: 19),),
                        )
                    ),



                  //DATE SELECTOR
                  if(_onlyUserLoggedIn)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 20),
                      child: Container(
                        width: _size.width * 0.9,
                        // color: Colors.red,
                        height: 70,
                        // could have used _size but fuck it whore-licks
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: timePickerBorder, width: 1.0), // Change the color and width as needed
                              borderRadius: BorderRadius.circular(10.0),
                            color: timePickerBg,
                            ),
                            child: DatePicker(
                              DateTime.now(),
                              width: 45,
                              monthTextStyle: _theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              dayTextStyle: _theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              dateTextStyle: _theme.textTheme.titleSmall!.copyWith(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              initialSelectedDate: DateTime.now(),
                              selectionColor: oldDateSelectBlue,
                              selectedTextColor: Colors.white,
                              onDateChange: (selectedDate) {
                                ref
                                    .read(dayProvider.notifier)
                                    .update((state) => selectedDate);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),


                  //DISPLAY THIS TIMETABLE
                  if (_onlyUserLoggedIn)
                    Container(
                      // height: MediaQuery.of(context).size.height * 2,
                      // width: MediaQuery.of(context).size.width * 0.9,
                      // color: Colors.red,
                      // child: Expanded(
                      //     child: Padding(
                      //       padding: EdgeInsets.all(20.0),
                      //       child: CardDisplay(),
                      //     ))
                      child: CardDisplay()

                      ,)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}