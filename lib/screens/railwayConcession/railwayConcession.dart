// ignore_for_file: lines_longer_than_80_chars
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_edit_modal.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_screen_appbar.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_field.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_with_divider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/station_list.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RailWayConcession extends ConsumerStatefulWidget {
  const RailWayConcession({super.key});

  @override
  ConsumerState<RailWayConcession> createState() => _RailWayConcessionState();
}

class _RailWayConcessionState extends ConsumerState<RailWayConcession> {
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();

  bool _iscomplete = false;
  bool _isfilled = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideButton: !_isfilled || _iscomplete,
      appBar: const RailwayAppBar(title: "Railway Concession"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // controller: listScrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/railwayConcession.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // _iscomplete
                            //     ? const Text("")
                            //     : Text(
                            //         "Please fill the form",
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .headlineMedium
                            //             ?.copyWith(fontWeight: FontWeight.w600),
                            //       )
                          ],
                        ),
                        _iscomplete
                            ? Container()
                            : RailwayEditModal(
                                isfilled: _isfilled,
                                setIsFilled: (val) =>
                                    setState(() => _isfilled = val),
                              ),
                      ],
                    ),
                  ),
                  !_iscomplete
                      ? Container()
                      : Align(
                          alignment: Alignment.center,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                                child: OverflowBox(
                                  minHeight: 200,
                                  maxHeight: 200,
                                  child: Lottie.network(
                                    'https://lottie.host/4587f75c-712e-4f2f-b41e-a142550cf0e1/vxuqbtWnpV.json',
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                    'Form is Submitted Successfully.We will get back to you soon'),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
