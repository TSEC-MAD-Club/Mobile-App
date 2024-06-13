import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/container_icon_with_label.dart';
// import 'package:tsec_app/new_ui/screens/home_screen/widgets/expanded_card.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/event_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';


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



class HomeWidget extends ConsumerStatefulWidget {
  Function(String page,int index) changeCurrentPage;
  HomeWidget({Key? key, required this.changeCurrentPage}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  List<EventModel> eventList = [];
  bool shouldLoop = true;

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
                      width: _size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(23, 0, 0, 20),
                        child: Text("Welcome ${data!=null?data.studentModel?.name.toLowerCase():"to rat race"}",style: TextStyle(color: Colors.white,fontSize: 19),),
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




                  //CALENDER STARTS HERE

                  if(data!=null)
                   Container(
                       width: _size.width,
                       child: Padding(
                         padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                         child: Text("Timetable",style: TextStyle(color: Colors.white,fontSize: 19),),
                       )
                   ),


                  //DATE SELECTOR
                  if (data == null)
                    Container(
                      width: _size.width,
                      height: _size.height*1.18,
                      child: DepartmentList(),
                    ),
                  if(data!=null)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: _size.width * 0.9,
                        // color: Colors.red,
                        height: 100,
                        // could have used _size but fuck it whore-licks
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: DatePicker(
                            DateTime.now(),
                            monthTextStyle: _theme.textTheme.headlineSmall!.copyWith(
                              fontSize: 15,
                              color: _theme.colorScheme.onTertiary,
                            ),
                            dayTextStyle: _theme.textTheme.headlineSmall!.copyWith(
                              fontSize: 15,
                              color: _theme.colorScheme.onTertiary,
                            ),
                            dateTextStyle: _theme.textTheme.titleSmall!.copyWith(
                              fontSize: 15,
                              color: _theme.colorScheme.onTertiary,
                            ),
                            initialSelectedDate: DateTime.now(),
                            selectionColor: _theme.colorScheme.onSecondary,
                            selectedTextColor: _theme.colorScheme.tertiaryContainer,
                            onDateChange: (selectedDate) {
                              ref
                                  .read(dayProvider.notifier)
                                  .update((state) => selectedDate);
                            },
                          ),
                        ),
                      ),
                    ),


                  //DISPLAY THIS TIMETABLE
                  if (data != null)
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
                  else
                    Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
