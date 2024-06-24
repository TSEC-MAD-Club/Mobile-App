import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_field.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_with_divider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/station_list.dart';

class RailwayEditModal extends ConsumerStatefulWidget {
  bool isfilled;
  Function setIsFilled;
  Function setIsComplete;

  RailwayEditModal({
    super.key,
    required this.isfilled,
    required this.setIsComplete,
    required this.setIsFilled,
  });

  @override
  ConsumerState<RailwayEditModal> createState() => _RailwayEditModalState();
}

class _RailwayEditModalState extends ConsumerState<RailwayEditModal> {
  String firstName = "";
  String middleName = "";
  String lastName = "";
  // String dateofbirth = "";
  String _ageYears = "";
  String _ageMonths = "";
  // String _age = "";
  String phoneNum = "";
  String? currYear;
  String? branch;
  String? duration;
  String? gender;
  String? travelLane;
  String? travelClass;
  String address = "";
  String homeStation = "";
  String toStation = "BANDRA";

  ScrollController listScrollController = ScrollController();

  String previousPassURL = "";
  String idCardURL = "";

  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  DateTime? _selectedDate;

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
      _ageMonths = months.toString();
      _ageYears = years.toString();
      ageController.text = "$_ageYears years $_ageMonths months";
      // debugPrint("updated ${ageController.text} ${dateOfBirthController.text}");
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
        // dateOfBirthController.text = picked.toLocal().toString().split(' ')[0];
        dateOfBirthController.text = DateFormat('dd MMM yyyy').format(picked);
        calculateAge(picked);
      });
    }
  }

  List<String> travelLanelist = ['Western', 'Central', 'Harbour'];
  List<String> travelClassList = ['I', 'II'];
  List<String> travedurationList = ['Monthly', 'Quarterly'];
  List<String> genderList = ['Male', 'Female'];
  List<String> currYearList = ['FE', 'SE', 'TE', 'BE'];
  List<String> branchList = ['COMPS', 'IT', 'AIDS', 'EXTC', "CHEMICAL"];

  void fetchConcessionDetails() async {
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);

    // debugPrint(
    //     "fetched concession details in railway concession UI: $concessionDetails");

    if (concessionDetails != null) {
      firstName = concessionDetails.firstName;
      middleName = concessionDetails.middleName;
      lastName = concessionDetails.lastName;
      _selectedDate = concessionDetails.dob;
      // dateOfBirthController.text =
      //     concessionDetails.dob.toDate().toString().split(' ')[0];
      dateOfBirthController.text = DateFormat('dd MMM yyyy')
          .format(concessionDetails.dob ?? DateTime.now());
      _ageYears = concessionDetails.ageYears.toString();
      _ageMonths = concessionDetails.ageMonths.toString();
      ageController.text =
          "${concessionDetails.ageYears} years ${concessionDetails.ageMonths} months";
      debugPrint(
          "fetched: ${dateOfBirthController.text} ${ageController.text}");
      phoneNum = concessionDetails.phoneNum.toString();
      currYear = concessionDetails.gradyear;
      branch = concessionDetails.branch;
      travelClass = concessionDetails.type;
      address = concessionDetails.address;
      duration = concessionDetails.duration;
      toStation = concessionDetails.to;
      homeStation = concessionDetails.from;
      gender = concessionDetails.gender;
      travelLane = concessionDetails.travelLane;
      idCardURL = concessionDetails.idCardURL;
      previousPassURL = concessionDetails.previousPassURL;
      getImageFileFromNetwork(concessionDetails.idCardURL, "idCard");
      getImageFileFromNetwork(
          concessionDetails.previousPassURL, "previousPass");
      //handle images
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchConcessionDetails();
  }

  File? idCardPhoto;
  File? previousPassPhoto;

  void pickImage(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == 'ID Card Photo') {
          idCardPhoto = File(pickedFile.path);
        } else if (type == 'Previous Pass Photo') {
          previousPassPhoto = File(pickedFile.path);
        }
      });
    }
  }

  Future<File> getImageFileFromNetwork(String url, String type) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;

      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      final String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.png';

      File imageFile = File('$tempPath/$fileName');
      await imageFile.writeAsBytes(bytes);

      if (type == "idCard") {
        setState(() {
          idCardPhoto = imageFile;
        });
      } else {
        setState(() {
          previousPassPhoto = imageFile;
        });
      }
      return imageFile;
    } else {
      throw Exception('Failed to load image from network');
    }
  }

  void cancelSelection(String type) {
    setState(() {
      if (type == 'ID Card Photo') {
        idCardPhoto = null;
      } else if (type == 'Previous Pass Photo') {
        previousPassPhoto = null;
      }
    });
  }

  Future _saveChanges(WidgetRef ref) async {
    ConcessionDetailsModel details = ConcessionDetailsModel(
      status: "unserviced",
      statusMessage: "",
      ageMonths: int.parse(_ageMonths),
      ageYears: int.parse(_ageYears),
      duration: duration ?? "Monthly",
      branch: branch ?? "AIDS",
      gender: gender ?? "Male",
      firstName: firstName,
      gradyear: currYear ?? "FE",
      middleName: middleName,
      lastName: lastName,
      idCardURL: idCardURL,
      previousPassURL: previousPassURL,
      from: homeStation,
      to: toStation,
      address: address,
      dob: _selectedDate ?? DateTime.now(),
      phoneNum: int.parse(phoneNum),
      travelLane: travelLane ?? "Western",
      type: travelClass ?? "I",
    );

    if (_formKey.currentState!.validate() &&
        idCardPhoto != null &&
        previousPassPhoto != null) {
      // await ref
      //     .watch(concessionProvider.notifier)
      //     .applyConcession(details, idCardPhoto!, previousPassPhoto!, context);
    }
  }

  TextEditingController homeStationController = TextEditingController();
  Widget buildImagePicker(String type, File? selectedPhoto) {
    File? selectedFile =
        type == 'ID Card Photo' ? idCardPhoto : previousPassPhoto;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$type',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 8),
          selectedFile == null
              ? OutlinedButton(
                  onPressed: () => pickImage(type),
                  child: Text('Choose Photo'),
                )
              : Column(
                  children: [
                    Stack(
                      children: [
                        selectedPhoto != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: FileImage(selectedPhoto),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 150,
                                width: 200,
                              )
                            : SizedBox.shrink(),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () => cancelSelection(type),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Column(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.isfilled ? 0.0 : 10.0,
              sigmaY: widget.isfilled ? 0.0 : 10.0,
            ),
            child: AnimatedCrossFade(
              duration: const Duration(seconds: 1),
              secondChild: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.95,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // border:
                  //     Border.all(color: Color(0xFF454545)),
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Make sure the details are Correct",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                RailwayTextField(
                                  initVal: firstName,
                                  onSaved: (newVal) {
                                    setState(() {
                                      if (newVal != null) {
                                        firstName = newVal;
                                      }
                                    });
                                  },
                                  label: 'First Name',
                                  isEditMode: !widget.isfilled,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null;
                                  },
                                ),

                                RailwayTextField(
                                  initVal: middleName,
                                  onSaved: (newVal) {
                                    setState(() {
                                      if (newVal != null) {
                                        middleName = newVal;
                                      }
                                    });
                                  },
                                  label: 'Middle Name',
                                  isEditMode: !widget.isfilled,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Middle Name';
                                    }
                                    return null;
                                  },
                                ),

                                RailwayTextField(
                                  initVal: lastName,
                                  onSaved: (newVal) {
                                    setState(() {
                                      if (newVal != null) {
                                        lastName = newVal;
                                      }
                                    });
                                  },
                                  label: 'Last Name',
                                  isEditMode: !widget.isfilled,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Last Name';
                                    }
                                    return null;
                                  },
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: DropdownButtonFormField(
                                          // Initial Value
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null; // Return null if the dropdown is valid
                                          },
                                          value: gender,
                                          hint: const Text(
                                            "Gender",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          // underline:
                                          //     Container(
                                          //   height: 1,
                                          //   color: Theme.of(
                                          //           context)
                                          //       .colorScheme
                                          //       .outline, // Change to your desired color
                                          // ),
                                          dropdownColor:
                                              Theme.of(context).primaryColor,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: genderList.map((String item) {
                                            return DropdownMenuItem(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                gender = newValue;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 65,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: DropdownButtonFormField(
                                          // Initial Value

                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null; // Return null if the dropdown is valid
                                          },
                                          value: branch,
                                          hint: const Text(
                                            "Branch",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          // underline:
                                          //     Container(
                                          //   height: 1,
                                          //   color: Theme.of(
                                          //           context)
                                          //       .colorScheme
                                          //       .outline, // Change to your desired color
                                          // ),
                                          dropdownColor:
                                              Theme.of(context).primaryColor,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: branchList.map((String item) {
                                            return DropdownMenuItem(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                branch = newValue;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 5, 4, 5),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Date of Birth",
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your date of birth';
                                            }
                                            return null;
                                          },
                                          controller: dateOfBirthController,
                                          keyboardType: TextInputType.datetime,
                                          readOnly: true,
                                          onTap: () => _selectDate(context),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              DateTime selectedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .parse(value);
                                              calculateAge(selectedDate);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 5, 4, 5),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Age",
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your age';
                                            }
                                            return null;
                                          },
                                          controller: ageController,
                                          readOnly: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: DropdownButtonFormField(
                                          // Initial Value
                                          value: duration,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null; // Return null if the dropdown is valid
                                          },
                                          hint: const Text(
                                            "Duration",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          dropdownColor:
                                              Theme.of(context).primaryColor,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: travedurationList
                                              .map((String item) {
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
                                    ),
                                    const SizedBox(
                                      width: 65,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: DropdownButtonFormField(
                                          // Initial Value
                                          value: travelLane,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null; // Return null if the dropdown is valid
                                          },
                                          hint: const Text(
                                            "Travel Lane",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          dropdownColor:
                                              Theme.of(context).primaryColor,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items:
                                              travelLanelist.map((String item) {
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
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        dropdownButtonProps:
                                            DropdownButtonProps(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelText: "Station",
                                          ),
                                        ),
                                        popupProps: PopupProps.dialog(
                                          showSearchBox: true,
                                        ),
                                        onChanged: (String? newVal) {
                                          if (newVal != null) {
                                            homeStation = newVal;
                                          }
                                        },
                                        items: mumbaiRailwayStations,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter your Home Station';
                                          }
                                          return null;
                                        },
                                      ),
                                      // dropdownBuilder:
                                      //     (context,
                                      //         selectedItem) {
                                      //   return Row(
                                      //     children: [
                                      //       Expanded(
                                      //         child:
                                      //             Text(
                                      //           selectedItem ??
                                      //               "",
                                      //           style:
                                      //               TextStyle(fontSize: 16),
                                      //         ),
                                      //       ),
                                      //       Icon(
                                      //         Icons
                                      //             .arrow_drop_down, // Your custom arrow icon goes here
                                      //         size:
                                      //             30,
                                      //       ),
                                      //     ],
                                      //   );
                                      // },
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
                                        isEditMode: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your destination';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      // width: MediaQuery.of(
                                      //             context)
                                      //         .size
                                      //         .width *
                                      //     0.95 /
                                      //     2,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            17, 5, 17, 5),
                                        child: DropdownButtonFormField(
                                          // Initial Value
                                          decoration: InputDecoration(
                                            // labelText:
                                            //     'Select an option',
                                            // Set the custom border color here
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline), // Change the color here
                                            ),
                                            // focusedBorder: OutlineInputBorder(
                                            //   borderSide:
                                            //       BorderSide(color: Colors.green), // Change the color here
                                            // ),
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null; // Return null if the dropdown is valid
                                          },
                                          value: travelClass,
                                          hint: const Text(
                                            "Class",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          // underline:
                                          //     Container(
                                          //   height: 1,
                                          //   color: Theme.of(
                                          //           context)
                                          //       .colorScheme
                                          //       .outline, // Change to your desired color
                                          // ),
                                          dropdownColor:
                                              Theme.of(context).primaryColor,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: travelClassList
                                              .map((String item) {
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
                                      width: MediaQuery.of(context).size.width *
                                          0.95 /
                                          3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            1, 5, .5, 5),
                                        child: DropdownButtonFormField(
                                          // Initial Value
                                          value: currYear,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null; // Return null if the dropdown is valid
                                          },
                                          hint: const Text(
                                            "Batch",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          // underline:
                                          //     Container(
                                          //   height: 1,
                                          //   color: Theme.of(
                                          //           context)
                                          //       .colorScheme
                                          //       .outline, // Change to your desired color
                                          // ),
                                          dropdownColor:
                                              Theme.of(context).primaryColor,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items:
                                              currYearList.map((String item) {
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
                                  isEditMode: !widget.isfilled,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Address';
                                    }
                                    return null;
                                  },
                                ),
                                RailwayTextField(
                                  isEditMode: !widget.isfilled,
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
                                // TODO: Previous Pass Photo
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment
                                  //         .spaceBetween,
                                  children: [
                                    buildImagePicker(
                                        'ID Card Photo', idCardPhoto),
                                    SizedBox(height: 16),
                                    buildImagePicker('Previous Pass Photo',
                                        previousPassPhoto),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!widget.isfilled &&
                                  _formKey.currentState!.validate()) {
                                if (idCardPhoto == null ||
                                    previousPassPhoto == null) {
                                  showSnackBar(context,
                                      "Please upload ID Card and previous pass photo");
                                  return;
                                }
                                await _saveChanges(ref);
                                widget.setIsComplete(true);
                                widget.setIsFilled(true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            child: Text(
                              "Sumbit",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
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
                                widget.setIsFilled(true);
                              },
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
              firstChild: SingleChildScrollView(
                child: Container(
                  height: 460,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // border:
                    //     Border.all(color: Color(0xFF454545)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    // color: Color(0xFF323232),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          RailwayTextWithDivider(
                              label: "First Name", value: firstName),
                          RailwayTextWithDivider(
                              label: "Middle Name", value: middleName),
                          RailwayTextWithDivider(
                              label: "Last Name", value: lastName),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.95 /
                                      2,
                                  child: RailwayTextWithDivider(
                                      label: "Gender", value: gender ?? "")),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.95 /
                                    3,
                                child: RailwayTextWithDivider(
                                    label: "Branch", value: branch ?? ""),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.95 /
                                      2,
                                  child: RailwayTextWithDivider(
                                      label: "DOB",
                                      value: dateOfBirthController.text)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.95 /
                                    3,
                                child: RailwayTextWithDivider(
                                    label: "Age", value: ageController.text),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.95 /
                                      2,
                                  child: RailwayTextWithDivider(
                                      label: "Duration",
                                      value: duration ?? "")),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.95 /
                                    3,
                                child: RailwayTextWithDivider(
                                    label: "Travel Lane",
                                    value: travelLane ?? ""),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.95 /
                                      2,
                                  child: RailwayTextWithDivider(
                                      label: "FROM", value: homeStation)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.95 /
                                    3,
                                child: RailwayTextWithDivider(
                                    label: "TO", value: toStation),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.95 /
                                      2,
                                  child: RailwayTextWithDivider(
                                      label: "Class",
                                      value: travelClass ?? "")),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.95 /
                                    3,
                                child: RailwayTextWithDivider(
                                    label: "Batch", value: currYear ?? ""),
                              ),
                            ],
                          ),
                          RailwayTextWithDivider(
                            label: "Address",
                            value: address,
                          ),
                          RailwayTextWithDivider(
                              label: "Phone No", value: phoneNum),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              crossFadeState: !widget.isfilled
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
          widget.isfilled
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.setIsFilled(false);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
                          const Text("APPLY"),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
