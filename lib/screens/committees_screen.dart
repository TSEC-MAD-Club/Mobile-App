import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsec_app/utils/image_assets.dart';

import '../models/committee_model/committee_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_scaffold.dart';

class CommitteesScreen extends StatefulWidget {
  const CommitteesScreen({Key? key}) : super(key: key);

  @override
  _CommitteesScreenState createState() => _CommitteesScreenState();
}

class _CommitteesScreenState extends State<CommitteesScreen> {
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
    return CustomScaffold(
      body: ListView(
        children: <Widget>[
          CustomAppBar(
            title: "Committees & Events",
            image: Image.asset(ImageAssets.committes),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          FutureBuilder<List<CommitteeModel>>(
            future: _committees,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
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
                              color: Theme.of(context).colorScheme.secondary,
                              child: CachedNetworkImage(
                                imageUrl: data[index].image,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 50,
                        ),
                        child: SingleChildScrollView(
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
