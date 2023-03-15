import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/company_model/company_model.dart';
import '../utils/image_assets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_scaffold.dart';

class TPCScreen extends StatefulWidget {
  const TPCScreen({Key? key}) : super(key: key);

  @override
  _TPCScreenState createState() => _TPCScreenState();
}

class _TPCScreenState extends State<TPCScreen> {
  late final Future<List<CompanyModel>> _companys;
  Future<List<CompanyModel>> _getCompanys() async {
    final data = await rootBundle.loadString("assets/data/companies.json");
    final json = jsonDecode(data) as List;
    return json.map((e) => CompanyModel.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _companys = _getCompanys();
  }

  List<Widget> getCompanyCards(List<CompanyModel> _companys) {
    List<Widget> list = [];
    for (var i = 0; i < _companys.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 1.25,
            right: 1.25,
          ),
          child: SizedBox(
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        left: 15.0,
                        right: 15.0,
                        bottom: 15,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: _companys[i].image,
                        height: 40,
                        width: 140,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Divider(color: Colors.blueAccent.withOpacity(0.7)),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        left: 15.0,
                        right: 15.0,
                        bottom: 10
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          child: Text(
                            _companys[i].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Training & Placement Cell",
              image: Image.asset(ImageAssets.tpo),
            ),
          )
        ],
        body: FutureBuilder<List<CompanyModel>>(
          future: _companys,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                crossAxisCount:
                    (MediaQuery.of(context).size.width / 250).ceil(),
                children: getCompanyCards(data),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
