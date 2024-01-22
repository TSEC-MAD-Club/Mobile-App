import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/utils/committee_details.dart';

import 'package:url_launcher/url_launcher_string.dart';

class EventDetail extends ConsumerStatefulWidget {
  final EventModel eventModel;
  const EventDetail({Key? key, required this.eventModel}) : super(key: key);

  @override
  ConsumerState<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  List<EventModel> eventList = [];

  void launchUrl() async {
    var url = widget.eventModel.eventRegistrationUrl;

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url.toString(),
          mode: LaunchMode.externalApplication);
    } else
      throw "Could not launch url";
  }

  @override
  Widget build(BuildContext context) {
    StudentModel? data = ref.watch(userModelProvider)?.studentModel;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CachedNetworkImage(
            imageUrl: widget.eventModel.imageUrl,
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.4),
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          CachedNetworkImage(
            imageUrl: widget.eventModel.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            height: (_height > _width) ? _height * 0.3 : _height * 0.5,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: (_height > _width) ? _height * 0.3 : _height * 0.5,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              widget.eventModel.eventName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          (data == null ||
                                  (widget.eventModel.eventRegistrationUrl
                                          .isEmpty ||
                                      widget.eventModel.eventRegistrationUrl ==
                                          ""))
                              ? const SizedBox()
                              : ElevatedButton(
                                  onPressed: () {
                                    launchUrl();
                                  },
                                  child: const Text("Register"),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 0, right: 20, left: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).backgroundColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.eventModel.eventLocation,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).backgroundColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.eventModel.eventTime +
                                      " " +
                                      widget.eventModel.eventDate,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: [
                          Text(
                            "About",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 10,
                        right: 20,
                      ),
                      child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunchUrlString(link.url)) {
                            await launchUrlString(link.url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        text: widget.eventModel.eventDescription,
                        style: Theme.of(context).textTheme.subtitle2,
                        linkStyle: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: [
                          Text(
                            "Organisers",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  getCommitteeImageByName(
                                      widget.eventModel.committeeName),
                                ),
                                backgroundColor: Colors.black,
                                radius: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.eventModel.committeeName,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
