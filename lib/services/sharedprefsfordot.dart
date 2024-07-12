import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesForDot{

  static late SharedPreferences prefs;

  static initializeSharedPreferences()async{
    prefs = await SharedPreferences.getInstance();
  }

  static int getNotificationNumber(){
    return prefs.getInt("notificationNumber") ?? 0;
  }

  static storeNotificationNumber(int value){
    prefs.setInt("notificationNumber", value);
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