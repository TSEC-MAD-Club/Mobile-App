// ignore_for_file: lines_longer_than_80_chars
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/concession_status_modal.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_dropdown_search.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_dropdown_field.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_text_field.dart';
import 'package:tsec_app/utils/railway_enum.dart';
import 'package:tsec_app/utils/station_list.dart';

class RailwayForm extends ConsumerStatefulWidget {
  const RailwayForm({super.key});

  @override
  ConsumerState<RailwayForm> createState() => _RailwayForm();
}

class _RailwayForm extends ConsumerState<RailwayForm> {
  // final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  String? status;
  String? statusMessage;
  String? duration;
  DateTime? lastPassIssued;

  // String?

  bool canIssuePass(ConcessionDetailsModel? concessionDetails,
      DateTime? lastPassIssued, String? duration) {
    if (concessionDetails?.status != null) {
      //user has applied for concession before

      // allow him to apply again if he was rejected
      if (concessionDetails!.status == ConcessionStatus.rejected) return true;

      // dont allow him to apply if his application is being processed
      if (concessionDetails.status == ConcessionStatus.unserviced) return false;

      //check date difference(only if status is serviced or downloaded)
      if (lastPassIssued == null) return true;
      DateTime today = DateTime.now();
      DateTime lastPass = lastPassIssued;
      int diff = today.difference(lastPass).inDays;
      bool retVal = (duration == "Monthly" && diff >= 30) ||
          (duration == "Quarterly" && diff >= 90);
      // debugPrint(retVal.toString());
      // debugPrint(status);
      return retVal;
    } else {
      //user has never applied for concession
      return true;
    }
  }

  String futurePassMessage() {
    DateTime today = DateTime.now();
    DateTime lastPass = lastPassIssued ?? DateTime.now();
    DateTime futurePass = lastPass.add(
        duration == "Monthly" ? const Duration(days: 27) : Duration(days: 87));
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
  String toStation = "Bandra";
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
      _selectedDate = concessionDetails.dob;
      dateOfBirthController.text = concessionDetails.dob != null
          ? DateFormat('dd MMM yyyy').format(concessionDetails.dob!)
          : "";
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
      // toStation = concessionDetails.to;
      // toStation = "Bandra";
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
      lastPassIssued = concessionDetails.lastPassIssued;
      duration = concessionDetails.duration;
    }
  }

  void clearValues() {
    /*if (!_formKey.currentState!.validate()) {
      print("HELLO");
      return;
    }*/
    ConcessionDetailsModel? concessionDetails =
        ref.watch(concessionDetailsProvider);
    firstNameController.text = concessionDetails?.firstName ?? "";
    middleNameController.text = concessionDetails?.middleName ?? "";
    lastNameController.text = concessionDetails?.lastName ?? "";
    addressController.text = concessionDetails?.address ?? "";
    phoneNumController.text = concessionDetails?.phoneNum.toString() ?? "";
    dateOfBirthController.text = concessionDetails?.dob != null
        ? DateFormat('dd MMM yyyy').format(concessionDetails!.dob!)
        : "";
    travelLane = concessionDetails?.travelLane ?? "Western";
    gender = concessionDetails?.gender ?? "Male";
    travelClass = concessionDetails?.type ?? "II";
    duration = concessionDetails?.duration ?? "Monthly";
    travelLane = concessionDetails?.travelLane ?? "Western";
    // toStation = concessionDetails?.to ?? "";
    homeStation = concessionDetails?.from ?? "";
    idCardPhotoTemp = idCardPhoto;
    previousPassPhotoTemp = previousPassPhoto;

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
      lastPassIssued: null,
      address: addressController.text,
      dob: _selectedDate ?? DateTime.now(),
      phoneNum: int.parse(phoneNumController.text),
      travelLane: travelLane ?? "Central",
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
      clearValues();
      Navigator.pop(context);
    } else if (idCardPhotoTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add the photo of your ID card")),
      );
    } else if (previousPassPhotoTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add the photo of your previous pass")),
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
                          // h = 150, w = 200
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.50,
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
    String currState = ref.watch(concessionProvider);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        //toolbarHeight: 80,
        title: Text("Railway Form",style: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(fontSize: 15, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: currState != ""
       ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 40.0,),
              SizedBox(
                width: 300.0,
                child: Text(
                  currState,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !editMode ? SizedBox(height: 10) : Container(),
            AnimatedContainer(
              duration: Duration(milliseconds: 5000),
              decoration: BoxDecoration(
                // color: commonbgblack,
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: !editMode
                    ? BorderRadius.all(Radius.circular(0)
                        // topLeft: Radius.circular(25.0),
                        // topRight: Radius.circular(25.0),
                        )
                    : BorderRadius.zero,
              ),
              /*height: ref.read(railwayConcessionOpenProvider.state).state
                      ? MediaQuery.of(context).size.height * .95
                      : MediaQuery.of(context).size.height * .57,*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
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
                                if (value==null || value.isEmpty) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
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
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            gender = newValue;
                                          });
                                        }
                                      }),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
                                  child: RailwayTextField(
                                    editMode: editMode,
                                    label: "Branch",
                                    val: student.branch,
                                    readOnly: true,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
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
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            travelClass = newValue;
                                          });
                                        }
                                      }),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
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
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            duration = newValue;
                                          });
                                        }
                                      }),
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
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      travelLane = newValue;
                                    });
                                  }
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
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
                                  width: MediaQuery.of(context).size.width * .45,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "To",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        toStation,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
                                buildImagePicker(
                                    'ID Card Photo', idCardPhotoTemp, editMode),
                                SizedBox(height: 16),
                                buildImagePicker('Previous Pass Photo',
                                    previousPassPhotoTemp, editMode),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width:MediaQuery.of(context).size.width * .43,
                            child: FilledButton(
                              onPressed: () {
                                print("Cleared Section");
                                clearValues();
                                Navigator.pop(context);
                              },
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      7.0), // Set the border radius
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                child: Text('Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width:MediaQuery.of(context).size.width * .43,
                            child: FilledButton(
                              onPressed: () {
                                saveChanges(ref);
                              },

                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      7.0), // Set the border radius
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiaryContainer,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                child: Text('Confirm',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
