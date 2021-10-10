import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsec_app/models/committee_model/committee_model.dart';

import '../widgets/custom_app_bar.dart';

class CommittessScreen extends StatefulWidget {
  const CommittessScreen({Key? key}) : super(key: key);

  @override
  _CommittessScreenState createState() => _CommittessScreenState();
}

class _CommittessScreenState extends State<CommittessScreen> {
  late final PageController _pageController;
  late final Future<List<CommitteeModel>> _committees;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.5,
    )..addListener(() {
        if (mounted) setState(() {});
      });

    _committees = _getCommittees();
  }

  Future<List<CommitteeModel>> _getCommittees() async {
    final data = await rootBundle.loadString("assets/data/committees.json");
    final json = jsonDecode(data) as List;
    return json.map((e) => CommitteeModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const CustomAppBar(
            title: "Committees & Events",
          ),
          const SizedBox(height: 25),
          FutureBuilder<List<CommitteeModel>>(
            future: _committees,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        onPageChanged: (page) {
                          _currentPage = page;
                        },
                        controller: _pageController,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final double currentPage =
                              _pageController.position.hasContentDimensions
                                  ? _pageController.page ?? 0
                                  : 0;

                          return Transform.scale(
                            scale: _getScale(index, currentPage),
                            child: Card(
                              color: Theme.of(context).accentColor,
                              child: CachedNetworkImage(
                                imageUrl: data[index].image,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 50,
                        ),
                        child: Column(
                          children: [
                            Text(
                              data[_currentPage].name,
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              data[_currentPage].description,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  double _getScale(int index, double page) {
    return 1 - (lerpDouble(0, .4, index - page) ?? 0).abs();
  }
}
