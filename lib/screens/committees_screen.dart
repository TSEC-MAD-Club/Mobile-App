// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsec_app/models/committee_model/committee_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Committees & Events",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder<List<CommitteeModel>>(
              future: _committees,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return CarouselSlider.builder(
                    itemCount: data.length,
                    options: CarouselOptions(
                      viewportFraction: 0.9,
                      height: 500,
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
                            color: _theme.colorScheme.outline,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    height: 100,
                                    width: 110,
                                    imageUrl: data[index].image,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data[index].name,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 250,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      data[_currentPage].description,
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white70, fontSize: 16),
                                      textAlign: TextAlign.left,
                                      // maxLines: 17,
                                      //overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
