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
import 'package:animations/animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_dropdown_search.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_dropdown_field.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_edit_modal.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_screen_appbar.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_text_field.dart';
import 'package:tsec_app/screens/railwayConcession/widgets/railway_text_with_divider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/railway_enum.dart';
import 'package:tsec_app/utils/station_list.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RailwayConcessionScreen extends ConsumerStatefulWidget {
  const RailwayConcessionScreen({super.key});

  @override
  ConsumerState<RailwayConcessionScreen> createState() =>
      _RailwayConcessionScreenState();
}

class _RailwayConcessionScreenState
    extends ConsumerState<RailwayConcessionScreen> {
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  String? status;
  String? statusMessage;
  String? duration;
  DateTime? lastPassIssued;

  bool canIssuePass(DateTime lastPassIssued, String duration) {
    DateTime today = DateTime.now();
    DateTime lastPass = lastPassIssued;
    int diff = today.difference(lastPass).inDays;
    bool retVal = (duration == "Monthly" && diff >= 30) ||
        (duration == "Quarterly" && diff >= 90);
    // debugPrint(retVal.toString());
    // debugPrint(status);
    return retVal;
  }

  String futurePassMessage() {
    DateTime today = DateTime.now();
    DateTime lastPass = lastPassIssued ?? DateTime.now();
    DateTime futurePass = lastPass.add(
        duration == "Monthly" ? const Duration(days: 30) : Duration(days: 90));
    int diff = futurePass.difference(today).inDays;
    return "You will be able to apply for a new pass after $diff days";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchConcessionDetails();
    if (status == "rejected") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     duration: Duration(milliseconds: 7000),
        //     content: Text(
        //         "Your concession service request has been rejected: $statusMessage")));
      });
    }
  }

  // String firstName = "";
  TextEditingController firstNameController = TextEditingController();
  // String middleName = "";
  TextEditingController middleNameController = TextEditingController();
  // String lastName = "";
  TextEditingController lastNameController = TextEditingController();
  // String dateofbirth = "";
  String _ageYears = "";
  String _ageMonths = "";
  // String _age = "";
  // String phoneNum = "";
  TextEditingController phoneNumController = TextEditingController();
  // String? duration;
  String? gender;
  String? travelLane;
  String? travelClass;
  // String address = "";
  TextEditingController addressController = TextEditingController();
  String homeStation = "";
  String toStation = "";
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // TextEditingController homeStationController = TextEditingController();
  // TextEditingController toStationController = TextEditingController();
  // String toStation = "BANDRA";

  ScrollController listScrollController = ScrollController();

  String previousPassURL = "";
  String idCardURL = "";

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

  Future<void> selectDate(BuildContext context) async {
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
  List<String> travelDurationList = ['Monthly', 'Quarterly'];
  List<String> genderList = ['Male', 'Female'];

  File? idCardPhoto;
  File? idCardPhotoTemp;
  File? previousPassPhoto;
  File? previousPassPhotoTemp;

  void pickImage(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == 'ID Card Photo') {
          // idCardPhoto = File(pickedFile.path);
          idCardPhotoTemp = File(pickedFile.path);
        } else if (type == 'Previous Pass Photo') {
          // previousPassPhoto = File(pickedFile.path);
          previousPassPhotoTemp = File(pickedFile.path);
        }
      });
    }
  }

  Future getImageFileFromNetwork(String url, String type) async {
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
          idCardPhotoTemp = imageFile;
        });
      } else {
        setState(() {
          previousPassPhoto = imageFile;
          previousPassPhotoTemp = imageFile;
        });
      }
    } else {
      throw Exception('Failed to load image from network');
    }
  }

  void cancelSelection(String type) {
    setState(() {
      if (type == 'ID Card Photo') {
        idCardPhotoTemp = null;
      } else if (type == 'Previous Pass Photo') {
        previousPassPhotoTemp = null;
      }
    });
  }

  void fetchConcessionDetails() async {
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);

    // debugPrint(
    //     "fetched concession details in railway concession UI: $concessionDetails");
    // debugPrint("over here ${concessionDetails?.firstName}");
    if (concessionDetails != null) {
      firstNameController.text = concessionDetails.firstName;
      middleNameController.text = concessionDetails.middleName;
      lastNameController.text = concessionDetails.lastName;
      _selectedDate = concessionDetails.dob.toDate();
      dateOfBirthController.text =
          DateFormat('dd MMM yyyy').format(concessionDetails.dob.toDate());
      _ageYears = concessionDetails.ageYears.toString();
      _ageMonths = concessionDetails.ageMonths.toString();
      ageController.text =
          "${concessionDetails.ageYears} years ${concessionDetails.ageMonths} months";
      // debugPrint(
      //     "fetched: ${dateOfBirthController.text} ${ageController.text}");
      phoneNumController.text = concessionDetails.phoneNum.toString();
      travelClass = concessionDetails.type;
      addressController.text = concessionDetails.address;
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

      status = concessionDetails.status;
      statusMessage = concessionDetails.statusMessage;
      lastPassIssued =
          concessionDetails.lastPassIssued?.toDate() ?? DateTime.now();
      duration = concessionDetails.duration;
    }
  }

  void clearValues() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);
    firstNameController.text = concessionDetails?.firstName ?? "";
    middleNameController.text = concessionDetails?.middleName ?? "";
    lastNameController.text = concessionDetails?.lastName ?? "";
    addressController.text = concessionDetails?.address ?? "";
    phoneNumController.text = concessionDetails?.phoneNum.toString() ?? "";
    dateOfBirthController.text = concessionDetails != null
        ? DateFormat('dd MMM yyyy').format(concessionDetails.dob.toDate())
        : "";
    travelLane = concessionDetails?.travelLane ?? "";
    gender = concessionDetails?.gender ?? "";
    travelClass = concessionDetails?.type ?? "";
    duration = concessionDetails?.duration ?? "";
    travelLane = concessionDetails?.travelLane ?? "";
    toStation = concessionDetails?.to ?? "";
    homeStation = concessionDetails?.from ?? "";
    idCardPhotoTemp = idCardPhoto;
    previousPassPhotoTemp = previousPassPhoto;

    ref.read(railwayConcessionOpenProvider.state).state = false;
  }

  Future saveChanges(WidgetRef ref) async {
    StudentModel student = ref.watch(userModelProvider)!.studentModel!;

    ConcessionDetailsModel details = ConcessionDetailsModel(
      status: ConcessionStatus.unserviced,
      statusMessage: "",
      ageMonths: int.parse(_ageMonths),
      ageYears: int.parse(_ageYears),
      duration: duration ?? "Monthly",
      branch: student.branch,
      gender: gender ?? "Male",
      firstName: firstNameController.text,
      gradyear: student.gradyear,
      middleName: middleNameController.text,
      lastName: lastNameController.text,
      idCardURL: idCardURL,
      previousPassURL: previousPassURL,
      from: homeStation,
      to: toStation,
      address: addressController.text,
      dob: Timestamp.fromDate(_selectedDate ?? DateTime.now()),
      phoneNum: int.parse(phoneNumController.text),
      travelLane: travelLane ?? "Western",
      type: travelClass ?? "I",
    );

    if (_formKey.currentState!.validate() &&
        idCardPhotoTemp != null &&
        previousPassPhotoTemp != null) {
      idCardPhoto = idCardPhotoTemp;
      previousPassPhoto = previousPassPhotoTemp;

      ref.read(railwayConcessionOpenProvider.state).state = false;
      await ref
          .watch(concessionProvider.notifier)
          .applyConcession(details, idCardPhoto!, previousPassPhoto!, context);
    } else if (idCardPhotoTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select the photo of your ID card")),
      );
    } else if (previousPassPhotoTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please select the photo of your previous pass")),
      );
    }
  }

  Widget buildImagePicker(String type, File? selectedPhoto, bool editMode) {
    // File? selectedFile =
    //     type == 'ID Card Photo' ? idCardPhoto : previousPassPhoto;

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
          selectedPhoto == null
              ? OutlinedButton(
                  onPressed: () => pickImage(type),
                  child: Text('Choose Photo'),
                )
              : Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: FileImage(selectedPhoto),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 150,
                          width: 200,
                        ),
                        editMode
                            ? Positioned(
                                top: -8,
                                right: -8,
                                child: IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.white),
                                  onPressed: () => cancelSelection(type),
                                ),
                              )
                            : Container(),
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
    bool editMode = ref.watch(railwayConcessionOpenProvider);
    StudentModel student = ref.watch(userModelProvider)!.studentModel!;
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: !editMode ? 10 : 0),
            !editMode
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: concessionDetails?.status ==
                                ConcessionStatus.rejected
                            ? Theme.of(context).colorScheme.error
                            : concessionDetails?.status == null ||
                                    lastPassIssued != null &&
                                        canIssuePass(lastPassIssued!, duration!)
                                ? Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer
                                : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(18),
                        // boxShadow: isItDarkMode
                        //     ? shadowLightModeTextFields
                        //     : shadowDarkModeTextFields,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        )),
                                Text(concessionDetails?.status ==
                                        ConcessionStatus.rejected
                                    ? "Rejected"
                                    : concessionDetails?.status ==
                                            ConcessionStatus.unserviced
                                        ? "Pending"
                                        : concessionDetails?.status == null ||
                                                lastPassIssued != null &&
                                                    canIssuePass(
                                                        lastPassIssued!,
                                                        duration!)
                                            ? "Can apply"
                                            : ""),
                              ],
                            ),
                            Text(concessionDetails?.statusMessage == null ||
                                    (lastPassIssued != null &&
                                        canIssuePass(
                                            lastPassIssued!, duration!))
                                ? "Apply for a new pass"
                                : concessionDetails!.statusMessage),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            !editMode ? SizedBox(height: 10) : Container(),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: !editMode
                    ? BorderRadius.all(Radius.circular(25)
                        // topLeft: Radius.circular(25.0),
                        // topRight: Radius.circular(25.0),
                        )
                    : BorderRadius.zero,
              ),
              height: editMode
                  ? MediaQuery.of(context).size.height * .95
                  : MediaQuery.of(context).size.height * .6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: editMode
                          ? MediaQuery.of(context).size.height * .8
                          : MediaQuery.of(context).size.height * .58,
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              RailwayTextField(
                                editMode: editMode,
                                label: "First Name",
                                controller: firstNameController,
                                readOnly: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your First Name';
                                  }
                                  return null;
                                },
                              ),
                              RailwayTextField(
                                editMode: editMode,
                                label: "Middle Name",
                                readOnly: false,
                                controller: middleNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Middle Name';
                                  }
                                  return null;
                                },
                              ),
                              RailwayTextField(
                                editMode: editMode,
                                label: "Last Name",
                                controller: lastNameController,
                                readOnly: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Middle Name';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayDropdownField(
                                      editMode: editMode,
                                      label: "Gender",
                                      items: genderList,
                                      val: gender,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select a gender';
                                        }
                                        return null;
                                      },
                                      onChanged: editMode
                                          ? (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  gender = newValue;
                                                });
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayTextField(
                                      readOnly: true,
                                      editMode: editMode,
                                      label: "DOB",
                                      controller: dateOfBirthController,
                                      onTap: () async {
                                        selectDate(context);
                                        // DateTime? pickedDate =
                                        //     await showDatePicker(
                                        //   context: context,
                                        //   initialDate: DateTime.now().subtract(
                                        //       Duration(days: 20 * 365)),
                                        //   firstDate: DateTime(1960),
                                        //   lastDate: DateTime(2010),
                                        // );
                                        // if (pickedDate != null) {
                                        //   String formattedDate =
                                        //       DateFormat('d MMMM y')
                                        //           .format(pickedDate);
                                        //   dateOfBirthController.text =
                                        //       formattedDate;
                                        // } else {
                                        //   // print(
                                        //   //     "Date is not selected");
                                        // }
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Date Of Birth';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayTextField(
                                      editMode: editMode,
                                      label: "Branch",
                                      val: student.branch,
                                      readOnly: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayTextField(
                                      readOnly: true,
                                      editMode: editMode,
                                      label: "Grad Year",
                                      val: student.gradyear,
                                    ),
                                  ),
                                ],
                              ),
                              RailwayTextField(
                                editMode: editMode,
                                label: "Phone Number",
                                controller: phoneNumController,
                                readOnly: false,
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
                                editMode: editMode,
                                label: "Address",
                                controller: addressController,
                                readOnly: false,
                                maxLines: 3,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Address';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayDropdownField(
                                      editMode: editMode,
                                      label: "Class",
                                      items: travelClassList,
                                      val: travelClass,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select a travel class';
                                        }
                                        return null;
                                      },
                                      onChanged: editMode
                                          ? (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  travelClass = newValue;
                                                });
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayDropdownField(
                                      editMode: editMode,
                                      label: "Duration",
                                      items: travelDurationList,
                                      val: duration,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select a travel duration';
                                        }
                                        return null;
                                      },
                                      onChanged: editMode
                                          ? (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  duration = newValue;
                                                });
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              RailwayDropdownField(
                                editMode: editMode,
                                label: "Travel Lane",
                                items: travelLanelist,
                                val: travelLane,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a travel lane';
                                  }
                                  return null;
                                },
                                onChanged: editMode
                                    ? (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            travelLane = newValue;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayDropdownSearch(
                                      editMode: editMode,
                                      label: "From",
                                      items: mumbaiRailwayStations,
                                      val: homeStation,
                                      onChanged: (String? newVal) {
                                        if (newVal != null) {
                                          homeStation = newVal;
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please enter your Home Station';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    child: RailwayDropdownSearch(
                                      editMode: editMode,
                                      label: "To",
                                      items: mumbaiRailwayStations,
                                      val: toStation,
                                      onChanged: (String? newVal) {
                                        if (newVal != null) {
                                          toStation = newVal;
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please enter your Destination Station';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment:
                                //     MainAxisAlignment
                                //         .spaceBetween,
                                children: [
                                  buildImagePicker('ID Card Photo',
                                      idCardPhotoTemp, editMode),
                                  SizedBox(height: 16),
                                  buildImagePicker('Previous Pass Photo',
                                      previousPassPhotoTemp, editMode),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    editMode
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FilledButton(
                                    onPressed: () {
                                      clearValues();
                                    },
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Set the border radius
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 12, 22, 12),
                                      child: Text('Cancel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              )),
                                    ),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      saveChanges(ref);
                                    },
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Set the border radius
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 12, 22, 12),
                                      child: Text('Confirm',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            SizedBox(height: !editMode ? 20 : 0),
            editMode
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () {
                            ref
                                .read(railwayConcessionOpenProvider.state)
                                .state = true;
                          },
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the border radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                            child: Text('Apply',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: Colors.black,
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
