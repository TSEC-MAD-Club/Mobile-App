import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedPreferencesForDot{

  static late SharedPreferences prefs;

  static initializeSharedPreferences()async{
    prefs = await SharedPreferences.getInstance();
  }

  static setNewNotificationDot()async{
    final getDocs = await FirebaseFirestore.instance.collection("notifications").get();
    storeNoOfNewNotification(getDocs.docs.length);
  }

  static int getNoOfNotification(){
    return prefs.getInt("noOfNotification") ?? 0;
  }

  static storeNoOfNotification(int value){
    prefs.setInt("noOfNotification", value);
  }

  static int getNoOfNewNotification(){
    return prefs.getInt("noOfNewNotification") ?? 0;
  }

  static storeNoOfNewNotification(int value){
    prefs.setInt("noOfNewNotification", value);
  }

  static makeNotificationEqual(){

  }

  static String getRailwayKeyStatus(){
    if(prefs.containsKey("railwayNotificationExists")){
      return prefs.getString("railwayNotificationExists") ?? "";
    }else{
      return "Key Not Present";
    }
  }

  static setRailwayKeyStatus(String conecessionStatus){
    print("Stored railwayNotificationExists as $conecessionStatus");
    prefs.setString("railwayNotificationExists", conecessionStatus);
  }

  static setRailwayDot(String concessionStatus){
    print("SetRailwayDot Called");
    final String status = prefs.getString("railwayNotificationExists") ?? "";
    if(concessionStatus != status){
      prefs.setBool("railwayDot", true);
    }else{
      prefs.setBool("railwayDot", false);
    }
    print("SetRailwayDot Value = ${getRailwayDot()}");
  }

  static bool getRailwayDot(){
    return prefs.getBool("railwayDot") ?? false;
  }










  // ShowCase Prefs
  static bool isFirstHome(){
    return prefs.getBool('firstHome') ?? false;
  }

  static firstHomeVisited(){
    prefs.setBool('firstHome',true);
  }

  static bool isFirstRailway(){
    return prefs.getBool('firstRailway') ?? false;
  }

  static void firstRailwayVisited() async{
    await prefs.setBool('firstRailway',true);
  }

  static bool isFirstTimeTable(){
    return prefs.getBool('firstTime') ?? false;
  }

  static void firstTimeTableVisited() async{
    await prefs.setBool('firstTime',true);
  }

  static bool isFirstGuide(){
    return prefs.getBool('firstGuide') ?? false;
  }

  static void firstTimeGuide() async{
    await prefs.setBool('firstGuide',true);
  }

  static bool isNotesVisited(){
    return prefs.getBool('notesVisited') ?? false;
  }

  static void visitNotes()async{
    await prefs.setBool('notesVisited',true);
  }
}