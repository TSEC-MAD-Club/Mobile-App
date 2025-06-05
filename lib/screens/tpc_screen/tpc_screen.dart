import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';

import '../../models/company_model/company_model.dart';

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
        InkWell(
          //onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> InternShips(),),),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 1.25,
              right: 1.25,
            ),
            child: SizedBox(
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(10),
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
                          // child: const TpcImageShimmer(),
                          child: CachedNetworkImage(
                            imageUrl: _companys[i].image,
                            imageBuilder: (context, imageProvider) => Column(
                              children: [
                                Image(
                                  image: imageProvider,
                                  height: 50,
                                  width: 140,
                                  fit: BoxFit.scaleDown,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                    color: Colors.grey.withOpacity(0.7),
                                    height: 1.5,
                                    width: double.infinity),
                              ],
                            ),
                            placeholder: (context, url) => Column(
                              children: const [
                                TpcImageShimmer(),
                                SizedBox(height: 20),
                                TpcDividerShimmer(),
                              ],
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                      // Divider(color: Colors.grey.withOpacity(0.7)),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            child: Text(_companys[i].name,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          // SliverToBoxAdapter(
          //   child: CustomAppBar(
          //     title: "Training & Placement Cell",
          //     image: Image.asset(ImageAssets.tpo),
          //   ),
          // )
        ],
        body: FutureBuilder<List<CompanyModel>>(
          future: _companys,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return GridView.count(
                // physics: const NeverScrollableScrollPhysics(),
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

class TpcImageShimmer extends StatelessWidget {
  const TpcImageShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer(
          color: Colors.grey,
          colorOpacity: 0.5,
          duration: const Duration(seconds: 3),
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            color: Colors.white12,
          ),
        ),
      ],
    );
  }
}

class TpcDividerShimmer extends StatelessWidget {
  const TpcDividerShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: Colors.grey,
      colorOpacity: 0.5,
      duration: const Duration(seconds: 3),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 1.5,
        color: Colors.white12,
      ),
    );
  }
}
