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

}

class dotClass {
  late SharedPreferences prefs;

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setNewNotificationDot() async {
    final getDocs = await FirebaseFirestore.instance.collection("notifications").get();
    storeNoOfNewNotification(getDocs.docs.length);
  }

  int getNoOfNotification() {
    return prefs.getInt("noOfNotification") ?? 0;
  }

  void storeNoOfNotification(int value) {
    prefs.setInt("noOfNotification", value);
  }

  int getNoOfNewNotification() {
    return prefs.getInt("noOfNewNotification") ?? 0;
  }

  void storeNoOfNewNotification(int value) {
    prefs.setInt("noOfNewNotification", value);
  }

  void makeNotificationEqual() {
    // Add your implementation
  }

}