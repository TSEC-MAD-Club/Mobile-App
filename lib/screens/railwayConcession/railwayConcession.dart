// ignore_for_file: lines_longer_than_80_chars

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_screen_appbar.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_field.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_with_divider.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';

class RailWayConcession extends ConsumerStatefulWidget {
  const RailWayConcession({super.key});

  @override
  ConsumerState<RailWayConcession> createState() => _RailWayConcessionState();
}

class _RailWayConcessionState extends ConsumerState<RailWayConcession> {
  String name = "";
  String? batch = "";
  String? currYear;
  String rollNo = "";
  String dateofbirth = "";
  String age = "";
  String? duration;
  String? travelLane;
  String? travelClass;
  String branch = "";
  String? div = "";
  String gradyear = "";
  String phoneNum = "";
  String address = "";
  String homeStation = "";
  String toStation = "BANDRA";
  String? profilePicUrl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController currYearController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController travelLaneController = TextEditingController();
  final TextEditingController travelClassController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController divController = TextEditingController();
  final TextEditingController gradYearController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController homeStationController = TextEditingController();
  final TextEditingController toStationController = TextEditingController();

  bool _isfilled = true;
  final _formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  String convertFirstLetterToUpperCase(String input) {
    if (input.isEmpty) {
      return input;
    }

    // Convert the entire string to lowercase first
    String lowerCaseInput = input.toLowerCase();

    // Get the first letter and convert it to uppercase
    String firstLetterUpperCase = lowerCaseInput[0].toUpperCase();

    // Combine the first letter with the rest of the lowercase string
    String convertedString = firstLetterUpperCase + lowerCaseInput.substring(1);

    return convertedString;
  }

  DateTime? _selectedDate;
  String _age = "";

  void calculateAge(DateTime dob) {
    DateTime currentDate = DateTime.now();
    int years = currentDate.year - dob.year;
    int months = currentDate.month - dob.month;
    if (currentDate.day < dob.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    setState(() {
      _age = "$years years $months months";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateOfBirthController.text = picked.toLocal().toString().split(' ')[0];
        calculateAge(picked);
      });
    }
  }

  List<String> divisionList = [];
  List<String> batchList = [];
  List<String> travelLanelist = ['Western', 'Central', 'Harbour'];
  List<String> travelClassList = ['I', 'II'];
  List<String> travedurationList = ['Monthly', 'Quarterly'];
  List<String> currYearList = ['FE', 'SE', 'TE', 'BE'];

  void calcDivisionList(String gradyear) {
    List<String> l = [];
    if (gradyear == "2027") {
      l = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
    } else if (branch == "Comps") {
      l = ["C1", "C2", "C3"];
    } else if (branch == "Chem") {
      l = ["K"];
    } else if (gradyear == "2026") {
      if (branch == "It" || branch == "Aids") {
        l = ["S1", "S2"];
      } else {
        l = ["A"];
      }
    } else if (gradyear == "2025") {
      if (branch == "It" || branch == "Aids") {
        l = ["T1", "T2"];
      } else {
        l = ["A"];
      }
    } else {
      //2024
      if (branch == "It") {
        l = ["B1", "B2"];
      } else {
        l = ["A"];
      }
    }
    setState(() {
      divisionList = l;
    });
  }

  void calcBatchList(String? div) {
    List<String> batches = [];
    if (div == null) {
      setState(() {
        batchList = batches;
      });
      return;
    }
    for (int i = 1; i <= 3; i++) {
      batches.add("$div$i");
    }
    // return batches;
    setState(() {
      batchList = batches;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.text = name ?? '';
    batchController.text = batch ?? '';
    currYearController.text = currYear ?? '';
    rollNoController.text = rollNo ?? '';
    dateOfBirthController.text = dateofbirth ?? '';
    ageController.text = _age ?? '';
    durationController.text = duration ?? '';
    travelLaneController.text = travelLane ?? '';
    travelClassController.text = travelClass ?? '';
    branchController.text = branch ?? '';
    divController.text = div ?? '';
    gradYearController.text = gradyear ?? '';
    phoneNumController.text = phoneNum ?? '';
    addressController.text = address ?? '';
    homeStationController.text = homeStation ?? '';
    toStationController.text = toStation ?? 'BANDRA';
  }

  Future _saveChanges(WidgetRef ref) async {
    // TODO : Logic after user submit the pass
  }
  bool _iscomplete = false;

  ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideButton: !_isfilled || _iscomplete,
      appBar: const RailwayAppBar(title: "Railway Concession"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: listScrollController,
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
                                    image: AssetImage("assets/images/railwayConcession.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _iscomplete
                                ? const Text("")
                                : Text(
                                    "Fill the form",
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                                  )
                          ],
                        ),
                        _iscomplete
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: 150.0),
                                child: Column(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: _isfilled ? 0.0 : 10.0,
                                        sigmaY: _isfilled ? 0.0 : 10.0,
                                      ),
                                      child: AnimatedCrossFade(
                                        duration: const Duration(seconds: 1),
                                        firstChild: Container(
                                          height: 460,
                                          width: MediaQuery.of(context).size.width * 0.95,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            // border:
                                            //     Border.all(color: Color(0xFF454545)),
                                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                                            // color: Color(0xFF323232),
                                            color: Theme.of(context).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Scrollbar(
                                                  thumbVisibility: true,
                                                  child: SingleChildScrollView(
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          RailwayTextField(
                                                            initVal: name,
                                                            onSaved: (newVal) {
                                                              setState(() {
                                                                if (newVal != null) {
                                                                  name = newVal;
                                                                }
                                                              });
                                                            },
                                                            label: 'Name',
                                                            isEditMode: _isfilled,
                                                            validator: (value) {
                                                              if (value!.isEmpty) {
                                                                return 'Please enter your Name';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: RailwayTextField(
                                                                  initVal: homeStation,
                                                                  onSaved: (newVal) {
                                                                    setState(() {
                                                                      if (newVal != null) {
                                                                        homeStation = newVal;
                                                                      }
                                                                    });
                                                                  },
                                                                  label: 'From',
                                                                  isEditMode: _isfilled,
                                                                  validator: (value) {
                                                                    if (value!.isEmpty) {
                                                                      return 'Please enter your Home Station';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: RailwayTextField(
                                                                  initVal: toStation,
                                                                  onSaved: (newVal) {
                                                                    setState(() {
                                                                      if (newVal != null) {
                                                                        toStation = newVal;
                                                                      }
                                                                    });
                                                                  },
                                                                  label: 'TO',
                                                                  isEditMode: !_isfilled,
                                                                  validator: (value) {
                                                                    if (value!.isEmpty) {
                                                                      return 'Please enter your BANDRA';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: TextFormField(
                                                                  controller: dateOfBirthController,
                                                                  keyboardType: TextInputType.datetime,
                                                                  decoration: const InputDecoration(
                                                                      border: InputBorder.none,
                                                                      labelText: "Date of Birth",
                                                                      labelStyle: TextStyle(
                                                                        color: Colors.grey,
                                                                      )),
                                                                  readOnly: true,
                                                                  onTap: () => _selectDate(context),
                                                                  onChanged: (value) {
                                                                    if (value.isNotEmpty) {
                                                                      DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(value);
                                                                      calculateAge(selectedDate);
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: CustomTextWithDivider(
                                                                label: "AGE",
                                                                value: _age,
                                                                showDivider: true,
                                                              )),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: DropdownButton(
                                                                  // Initial Value
                                                                  value: duration,
                                                                  hint: const Text(
                                                                    "Duration",
                                                                    style: TextStyle(color: Colors.grey),
                                                                  ),
                                                                  underline: Container(
                                                                    height: 1,
                                                                    color: Theme.of(context).colorScheme.outline, // Change to your desired color
                                                                  ),
                                                                  dropdownColor: Theme.of(context).primaryColor,
                                                                  icon: const Icon(Icons.keyboard_arrow_down),
                                                                  // Array list of items
                                                                  items: travedurationList.map((String item) {
                                                                    return DropdownMenuItem(
                                                                      value: item,
                                                                      child: Text(item),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (String? newValue) {
                                                                    if (newValue != null) {
                                                                      setState(() {
                                                                        duration = newValue;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 65,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                                                child: DropdownButton(
                                                                  // Initial Value
                                                                  value: travelLane,
                                                                  hint: const Text(
                                                                    "Travel Lane",
                                                                    style: TextStyle(color: Colors.grey),
                                                                  ),
                                                                  underline: Container(
                                                                    height: 1,
                                                                    color: Theme.of(context).colorScheme.outline, // Change to your desired color
                                                                  ),
                                                                  dropdownColor: Theme.of(context).primaryColor,
                                                                  icon: const Icon(Icons.keyboard_arrow_down),
                                                                  // Array list of items
                                                                  items: travelLanelist.map((String item) {
                                                                    return DropdownMenuItem(
                                                                      value: item,
                                                                      child: Text(item),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (String? newValue) {
                                                                    if (newValue != null) {
                                                                      setState(() {
                                                                        travelLane = newValue;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.95 / 2,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
                                                                  child: DropdownButton(
                                                                    // Initial Value
                                                                    value: travelClass,
                                                                    hint: const Text(
                                                                      "Class",
                                                                      style: TextStyle(color: Colors.grey),
                                                                    ),
                                                                    underline: Container(
                                                                      height: 1,
                                                                      color: Theme.of(context).colorScheme.outline, // Change to your desired color
                                                                    ),
                                                                    dropdownColor: Theme.of(context).primaryColor,
                                                                    icon: const Icon(Icons.keyboard_arrow_down),
                                                                    // Array list of items
                                                                    items: travelClassList.map((String item) {
                                                                      return DropdownMenuItem(
                                                                        value: item,
                                                                        child: Text(item),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (String? newValue) {
                                                                      if (newValue != null) {
                                                                        setState(() {
                                                                          travelClass = newValue;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.95 / 3,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(1, 5, .5, 5),
                                                                  child: DropdownButton(
                                                                    // Initial Value
                                                                    value: currYear,
                                                                    hint: const Text(
                                                                      "(FE/SE/TE/BE)",
                                                                      style: TextStyle(color: Colors.grey, fontSize: 13),
                                                                    ),
                                                                    underline: Container(
                                                                      height: 1,
                                                                      color: Theme.of(context).colorScheme.outline, // Change to your desired color
                                                                    ),
                                                                    dropdownColor: Theme.of(context).primaryColor,
                                                                    icon: const Icon(Icons.keyboard_arrow_down),
                                                                    // Array list of items
                                                                    items: currYearList.map((String item) {
                                                                      return DropdownMenuItem(
                                                                        value: item,
                                                                        child: Text(item),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (String? newValue) {
                                                                      if (newValue != null) {
                                                                        setState(() {
                                                                          currYear = newValue;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          RailwayTextField(
                                                            initVal: address,
                                                            onSaved: (newVal) {
                                                              setState(() {
                                                                if (newVal != null) {
                                                                  address = newVal;
                                                                }
                                                              });
                                                            },
                                                            maxLines: 2,
                                                            label: 'Address',
                                                            isEditMode: _isfilled,
                                                            validator: (value) {
                                                              if (value!.isEmpty) {
                                                                return 'Please enter your Address';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          RailwayTextField(
                                                            isEditMode: _isfilled,
                                                            label: "Phone Number",
                                                            initVal: phoneNum,
                                                            onSaved: (newVal) {
                                                              setState(() {
                                                                if (newVal != null) {
                                                                  phoneNum = newVal;
                                                                }
                                                              });
                                                            },
                                                            validator: (value) {
                                                              if (value!.isEmpty) {
                                                                return 'Please enter a phone number';
                                                              }
                                                              if (!isValidPhoneNumber(value)) {
                                                                return 'Please enter a valid phone number';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          RailwayTextField(
                                                            isEditMode: _isfilled,
                                                            label: "Branch",
                                                            // controller:
                                                            //     _branchController,
                                                            initVal: branch,
                                                            onSaved: (newVal) {
                                                              setState(() {
                                                                if (newVal != null) {
                                                                  branch = newVal;
                                                                }
                                                              });
                                                            },
                                                            enabled: true,
                                                          ),
                                                          // TODO: Previous Pass Photo
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        secondChild: Container(
                                          height: 520,
                                          width: MediaQuery.of(context).size.width * 0.95,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            // border:
                                            //     Border.all(color: Color(0xFF454545)),
                                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                                            // color: Color(0xFF323232),
                                            color: Theme.of(context).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "Make sure the details are Correct",
                                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Theme.of(context).colorScheme.outline,
                                                ),
                                                RailwayTextWithDivider(label: "Name", value: name),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.95 / 2,
                                                        child: RailwayTextWithDivider(label: "FROM", value: homeStation)),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.95 / 3,
                                                      child: RailwayTextWithDivider(label: "TO", value: toStation),
                                                    ),
                                                  ],
                                                ),
                                                RailwayTextWithDivider(label: "Class", value: travelClass ?? "Please specify the class"),
                                                RailwayTextWithDivider(label: "Duration", value: duration ?? 'Please specify a duration'),
                                                RailwayTextWithDivider(
                                                  label: "Address",
                                                  value: address,
                                                ),
                                                RailwayTextWithDivider(label: "Phone No", value: phoneNum),
                                                Row(
                                                  children: [
                                                    const Spacer(),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (!_isfilled) {
                                                            _iscomplete = true;
                                                          }
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                                          backgroundColor: Colors.green,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(50.0), // Half of desired button height
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Save Changes",
                                                          style: TextStyle(
                                                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _isfilled = true;
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons.cancel_outlined,
                                                            color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                                        crossFadeState: !_isfilled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  !_iscomplete
                      ? (_isfilled
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_isfilled) {
                                    setState(() {
                                      _isfilled = false;
                                    });
                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                      if (listScrollController.hasClients) {
                                        final position = listScrollController.position.viewportDimension;
                                        listScrollController.animateTo(
                                          position,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
                                    const Text("CHECK"),
                              ),
                            )
                          : Container())
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
                                child: Text('Form is Submitted Successfully.We will get back to you soon'),
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
