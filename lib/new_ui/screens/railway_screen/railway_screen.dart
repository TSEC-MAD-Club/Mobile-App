// ignore_for_file: lines_longer_than_80_chars
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/models/concession_request_model/concession_request_model.dart';
// import 'package:tsec_app/models/concession_request_model/concession_request_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/screens/guidelines_screen/guidelinesscreen.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railwayform.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/concession_status_modal.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_dropdown_search.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_dropdown_field.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/stepperwidget.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/concession_request_provider.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/widgets/railway_text_field.dart';
import 'package:tsec_app/utils/railway_enum.dart';
import 'package:tsec_app/utils/station_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RailwayConcessionScreen extends ConsumerStatefulWidget {
  const RailwayConcessionScreen({super.key});

  @override
  ConsumerState<RailwayConcessionScreen> createState() =>
      _RailwayConcessionScreenState();
}

class _RailwayConcessionScreenState
    extends ConsumerState<RailwayConcessionScreen> {
  // final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  String? status;
  String? statusMessage;
  String? duration;
  DateTime? lastPassIssued;
  String? from;
  String? to;

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

      // eg: if lastPassIssued if 6th June, it expires on 5th July then allow user to apply for pass from 2nd,3rd,4th July, 3days prior to pass ends
      bool retVal = (duration == "Monthly" && diff >= 26) ||
          (duration == "Quarterly" && diff >= 86);
      // debugPrint(retVal.toString());
      // debugPrint(status);
      return retVal;
    } else {
      //user has never applied for concession
      return true;
    }
  }

  String futurePassMessage(concessionDetails) {
    if (canIssuePass(concessionDetails, lastPassIssued, duration)) {
      return "⚠️ NOTE: You can tap above to apply for the Pass";
    }

    if (status=="unserviced" || lastPassIssued==null) {
      return "⚠️ NOTE: You need to wait until your request is granted";
    }

    DateTime today = DateTime.now();
    DateTime lastPass = lastPassIssued ?? DateTime.now();
    DateTime futurePass = lastPass.add(duration == "Monthly" ? const Duration(days: 27) : const Duration(days: 87));
    int diff = futurePass.difference(today).inDays;

    if (diff==1){
      return "⚠️ NOTE: You will be able to apply for a new pass only after $diff day";
    }
    return "⚠️ NOTE: You will be able to apply for a new pass only after $diff days";
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
      // await ref
      //     .watch(concessionProvider.notifier)
      //     .applyConcession(details, idCardPhoto!, previousPassPhoto!, context);
    } else if (idCardPhotoTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add the photo of your ID card")),
      );
    } else if (previousPassPhotoTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add the photo of your previous pass")),
      );
    }

    ref.read(concessionProvider.notifier).getConcessionData();
    ref.read(concessionRequestProvider.notifier).getConcessionRequestData();
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


  void initState() {
    super.initState();

    // Fetch data once when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(concessionProvider.notifier).getConcessionData();
      ref.read(concessionRequestProvider.notifier).getConcessionRequestData();
    });
  }
  



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool editMode = ref.watch(railwayConcessionOpenProvider);
    ConcessionDetailsModel? concessionDetails = ref.watch(concessionDetailsProvider);
    ConcessionRequestModel? concessionRequestData = ref.watch(concessionRequestDetailProvider);
    String formattedDate = lastPassIssued != null
        ? DateFormat('dd/MM/yyyy').format(lastPassIssued!)
        : 'null';

    String currState = ref.watch(concessionProvider);
    bool buttonTrigger(ConcessionStatus){
      if(status == ConcessionStatus.rejected){
        return true;
      }else if(status == ConcessionStatus.unserviced){
        return false;
      }else if(status == ConcessionStatus.serviced && canIssuePass(concessionDetails, lastPassIssued, duration)){
        return true;
      }else {
        return false;
      }
    }
    print("Inside Build = ${concessionRequestData?.toJson()}");
    return currState != ""
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currState != "Applied successfully"
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: 50.0,
                  height: 50.0,
                  // child: Lottie.asset('assets/animation/ffffff.json'),
                  child: Image.asset("assets/images/tick2.png")
                ),
              currState != "Applied successfully"
              ? const SizedBox(height: 40.0,)
              : const SizedBox(height: 20.0,),
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
        :
    SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            StatusStepper(concessionStatus: concessionDetails?.status == null ? "" : concessionDetails!.status, concessionRequestData: concessionRequestData,),
            // SizedBox(height: 10),
            if(concessionRequestData!=null && concessionRequestData.statusMessage!=null && concessionRequestData.status=="rejected" && concessionRequestData.statusMessage!="")
              Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Reason: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: "${concessionRequestData!.statusMessage}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Container(
              width: size.width * 0.7,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                onTap: () {
                  if (canIssuePass(concessionDetails, concessionDetails?.lastPassIssued, concessionDetails?.duration)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RailwayForm(),
                      ),
                    );
                  }
                },
                child: ConcessionStatusModal(
                  canIssuePass: canIssuePass,
                  futurePassMessage: futurePassMessage,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: size.width * 0.9,
              alignment: Alignment.center,
              child: Text(
                futurePassMessage(concessionDetails),
                style: TextStyle(fontSize: 15, color: Colors.yellow),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            if (concessionDetails?.status != null && (concessionDetails!.status == 'serviced' || concessionDetails!.status == 'unserviced'))
              //Old UI Container
              /*Container(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    concessionDetails.status == "serviced"
                        ? Text("Ongoing Pass",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ) : Text("Applied Pass", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          concessionDetails.status != "unserviced" ? Text(
                              "Certificate Num: ${concessionRequestData != null
                                  ? concessionRequestData.passNum
                                  : "not assigned"}",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ) : SizedBox(),
                          concessionDetails.status != "unserviced" ? SizedBox(
                              height: 15,
                            ) : SizedBox(),
                          concessionDetails.status != "unserviced" ? Text(
                              "Date of Issue: $formattedDate",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ) : SizedBox(),
                          concessionDetails.status != "unserviced" ? SizedBox(
                              height: 15,
                            ) : SizedBox(),
                          Text(
                            "Travel Lane: ${travelLane}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "From: ${homeStation}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "To: ${toStation}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Duration: ${duration}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "Class: ${travelClass}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),

                          if (concessionRequestData?.passCollected != null &&
                              concessionRequestData!.passCollected!['collected'] == "1") ...[
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Pass collected on ${DateFormat('dd/MM/yyyy').format((concessionRequestData.passCollected!['date'] as Timestamp).toDate())}",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],


                        ],
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> GuideLinesScreen(),),),child: Text("View Guidelines",style: TextStyle(color: Colors.white),),),

                  ],
                ),
              )*/

               Column(
                 children: [
                   SizedBox(
                     height: 90,
                     child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (concessionDetails!.status == "serviced")
                          Positioned(top: 50,child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(size.width*0.1),topRight: Radius.circular(size.width*0.1),),
                            ),
                            child: const SizedBox(height: 50,),
                          ),)
                          else
                            Positioned(bottom: 20, child: Text("You don't have any ongoing pass",
                            style: TextStyle(color: Colors.white),),),
                          Positioned(top: 20,child: Container(
                            width: size.width*0.75,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(size.width*0.05),
                              border: Border.all(color: Colors.white),
                              boxShadow: [
                                BoxShadow(offset: Offset.fromDirection(2),spreadRadius: 2,color: Colors.black,blurRadius: 2)
                              ],
                            ),
                            alignment: Alignment.center,
                            height: 60,
                            child: const Text("Text to be Displayed Here",style: TextStyle(color: Colors.white),),
                          ),),
                        ],
                      ),
                   ),
                   Container(
                     width: size.width,
                     height: size.height*0.4,
                     decoration: const BoxDecoration(
                       color: Colors.blue,
                       border: Border.symmetric(vertical: BorderSide(color: Colors.white),),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Text("Ongoing Pass",
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Certificate Number", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                    Text("${concessionRequestData != null ? concessionRequestData.passNum : "not assigned"}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                 ],
                               ),
                               Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
                                    Text("Date of Issue", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                    Text(formattedDate, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                 ],
                               )
                             ],
                           ),
                           const SizedBox(height: 15,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Travel Lane", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                      Text("${travelLane}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("From", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                    Text("${homeStation}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
                                    Text("To", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                    Text("Bandra", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                 ],
                               )
                             ],
                           ),
                           const SizedBox(height: 15,),
                           Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Duration of pass", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                    Text("${duration}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Class", style: TextStyle(color: Color(0xffe3e3e3), fontSize: 12),),
                                    Text(travelClass == "I" ? "First Class" : "Second Class", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                //const SizedBox()
                              ],
                            ),
                         ],
                       ),
                     ),
                   ),
                 ],
               )



            else
              Container(
                width: size.width * 0.8,
                height: size.height*0.3,
                alignment: Alignment.center,
                child: Text(
                  "You Dont have any ongoing pass",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
