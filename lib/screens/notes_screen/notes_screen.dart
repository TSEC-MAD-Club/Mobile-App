import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tsec_app/utils/image_assets.dart';
import 'package:tsec_app/utils/themes.dart';
import 'package:tsec_app/widgets/custom_app_bar.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isFilterVisible = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleFilterVisibility() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    bool isItDarkMode = brightness == Brightness.dark;
    return CustomScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Notes",
              image: Image.asset(ImageAssets.notes),
            ),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isItDarkMode
                              ? shadowLightModeTextFields
                              : shadowDarkModeTextFields,
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: _toggleFilterVisibility,
                              icon: const Icon(
                                Icons.tune,
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (Theme.of(context).primaryColor ==
                                        const Color(0xFFF2F5F8))
                                    ? Colors.black54
                                    : Colors.white38,
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: (Theme.of(context).primaryColor ==
                                      const Color(0xFFF2F5F8))
                                  ? Colors.grey[500]
                                  : Colors.white60,
                            ),
                            hintText: "Search",
                            fillColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      if (_isFilterVisible)
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(16.0),
                height: _isFilterVisible ? 500 : 0,
                decoration: BoxDecoration(
                  color: kDarkModeToggleBtnBg,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isItDarkMode
                        ? shadowLightModeTextFields
                        : shadowDarkModeTextFields,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 160,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text("Start date"),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                              child: Icon(
                                Icons.arrow_right_alt_rounded,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text("End date"),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 170,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text("Latest"),
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text("Oldest"),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            const Text("Subjects"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("TSEC Official"),
                                  ),
                                ),
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("DWM"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("CN"),
                                  ),
                                ),
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("WC"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("AI"),
                                  ),
                                ),
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("Stats"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("MPR"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      50.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            // main
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: _toggleFilterVisibility,
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
