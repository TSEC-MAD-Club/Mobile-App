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
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png",
            fit: BoxFit.cover,
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
                          const Text(
                            "TSEC HACKS 2022",
                            style: TextStyle(fontSize: 20, color: Colors.black),
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
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "302, Old Building",
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
                        children: const [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "3:00 PM, 11th july 2022",
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
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Text(
                        "Nobody wants to stare at a blank wall all day long, which is why wall art is such a crucial step in the decorating process. And once you start brainstorming, the rest is easy. From gallery walls to DIY pieces like framing your accessories and large-scale photography, we've got plenty of wall art ideas to spark your creativity. And where better to look for inspiration that interior designer-decorated walls",
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
