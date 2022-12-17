import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/provider/event_provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
      await launchUrlString(url);
    } else
      throw "Could not launch url";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.eventModel.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            height: 220,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              String registerUri = widget.eventModel.imageUrl;

                              launchUrl();
                            },
                            child: const Text("Register"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, right: 20, left: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.eventModel.eventLocation,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.eventModel.eventTime +
                                " " +
                                widget.eventModel.eventDate,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: const [
                          Text(
                            "About",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Text(
                        widget.eventModel.eventDescription,
                        style: TextStyle(
                            height: 1.6, color: Colors.black, fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: const [
                          Text(
                            "Organisers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: const NetworkImage(
                                'https://cdn.pixabay.com/photo/2013/05/11/08/28/sunset-110305_1280.jpg'),
                            backgroundColor: Colors.red.shade800,
                            radius: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "TSEC CodeCell",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
