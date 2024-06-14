// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tsec_app/models/committee_model/committee_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';

class CommitteesScreen extends StatefulWidget {
  const CommitteesScreen({Key? key}) : super(key: key);

  @override
  _CommitteesScreenState createState() => _CommitteesScreenState();
}

class _CommitteesScreenState extends State<CommitteesScreen> {
  late final Future<List<CommitteeModel>> _committees;

  @override
  void initState() {
    super.initState();
    _committees = _getCommittees();
  }

  Future<List<CommitteeModel>> _getCommittees() async {
    final data = await rootBundle.loadString("assets/data/committees.json");
    final json = jsonDecode(data) as List;
    return json.map((e) => CommitteeModel.fromJson(e)).toList();
  }

  // ignore: unused_field
  int _currentPage = 0;
  int committeesLength = 16;
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CommonAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                top: 15,
              ),
              child: Text(
                "Committees & Events",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),*/
            const SizedBox(
              height: 25,
            ),
            FutureBuilder<List<CommitteeModel>>(
              future: _committees,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  committeesLength = data.length;
                  return CarouselSlider.builder(
                    itemCount: data.length,
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 500),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                      // height: 550,
                      height: _height * 0.65,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, _) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: _theme.colorScheme.outline,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    height: 130,
                                    width: 130,
                                    imageUrl: data[index].image,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  data[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 15),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: _height * 0.33,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        data[_currentPage].description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize: 18),
                                        textAlign: TextAlign.left,
                                        // maxLines: 17,
                                        //overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: committeesLength,
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  spacing: 8,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
