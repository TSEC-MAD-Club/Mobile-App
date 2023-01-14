import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/event_model/event_model.dart';

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
        alignment: Alignment.topCenter,
        children: [
          CachedNetworkImage(
            imageUrl: widget.eventModel.imageUrl,
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.4),
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          CachedNetworkImage(
            imageUrl: widget.eventModel.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.29),
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
                          ElevatedButton(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).backgroundColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.eventModel.eventLocation,
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Theme.of(context).backgroundColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.eventModel.eventTime +
                                " " +
                                widget.eventModel.eventDate,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
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
                      child: Text(
                        widget.eventModel.eventDescription,
                        style: Theme.of(context).textTheme.subtitle2,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: const NetworkImage(
                              'https://cdn.pixabay.com/photo/2013/05/11/08/28/sunset-110305_1280.jpg',
                            ),
                            backgroundColor: Colors.red.shade800,
                            radius: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "TSEC CodeCell",
                            style: Theme.of(context).textTheme.subtitle1,
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
