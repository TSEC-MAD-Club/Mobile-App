import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202022-12-13%20at%2019.16.12.jpeg?alt=media&token=fcb02f10-a68f-4a59-aa13-11e3b99134c2",
            color: Colors.white.withOpacity(0.4),
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          CachedNetworkImage(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202022-12-13%20at%2019.16.12.jpeg?alt=media&token=fcb02f10-a68f-4a59-aa13-11e3b99134c2",
            fit: BoxFit.cover,
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
                          Text(
                            "TSEC HACKS 2022",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
                            "302, Old Building",
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
                            "3:00 PM, 11th july 2022",
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
                        "Nobody wants to stare at a blank wall all day long.",
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
