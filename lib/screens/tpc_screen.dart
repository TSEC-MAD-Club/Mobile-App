import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsec_app/utils/image_assets.dart';
import '../models/company_model/company_model.dart';
import '../widgets/custom_app_bar.dart';

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
    if (mounted) setState(() {});
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
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 22.0,
                        left: 15.0,
                        right: 15.0,
                        bottom: 20,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: _companys[i].image,
                        height: 40,
                        width: 140,
                      ),
                    ),
                    Divider(color: Colors.blueAccent.withOpacity(0.7)),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: Text(
                        _companys[i].name,
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                        textAlign: TextAlign.center,
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
    return Scaffold(
      body: ListView(
        children: <Widget>[
          CustomAppBar(
            title: "Training & Placement Cell",
            image: Image.asset(ImageAssets.tpo),
          ),
          const SizedBox(height: 25),
          FutureBuilder<List<CompanyModel>>(
            future: _companys,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 25,
                  width: MediaQuery.of(context).size.width - 25,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    children: getCompanyCards(data),
                  ),
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
}
