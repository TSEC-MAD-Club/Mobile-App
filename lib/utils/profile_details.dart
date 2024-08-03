List<String> calcDivisionList(String gradyear, String branch) {
  List<String> l = [];

  // currentAcdYear -> Current Academic Year;
  String currentAcdYear = calcGradYear(gradyear);

  if (currentAcdYear == "FE") {
    l = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
  }

  else if (branch == "Comps") {
    l = ["C1", "C2", "C3"];
  }

  else if (branch == "Chem") {
    l = ["K"];
  }

  else if (currentAcdYear == "SE") {
    if (branch == "It" || branch == "Aids") {
      l = ["S1", "S2"];
    } else {
      l = ["A"];
    }
  }

  else if (currentAcdYear == "TE") {
    if (branch == "It" || branch == "Aids") {
      l = ["T1", "T2"];
    } else {
      l = ["A"];
    }
  }

  else if (currentAcdYear == "BE") {
    if (branch == "It" || (branch == "Aids" && gradyear!= "2024")) {
      l = ["B1", "B2"];
    } else {
      l = ["A"];
    }
  }

  return l;

}

List<String> allYearList = ['FE', 'SE', 'TE', 'BE'];
List<String> allBranchList = ['Comps', 'It', 'Aids', 'Extc', "Chem"];

Map<String, String> gradYearMapping = {};
class MapsYear {

  static mapGradYear(){
    // Get the current date and time
    DateTime now = DateTime.now();

    // Extract the current year
    int currentYear = now.year;

    // Extract the current month
    int currentMonth = now.month;

    if(currentMonth >=7 && currentMonth <=12){
      gradYearMapping["FE"] = (currentYear + 4).toString();
      gradYearMapping["SE"] = (currentYear + 3).toString();
      gradYearMapping["TE"] = (currentYear + 2).toString();
      gradYearMapping["BE"] = (currentYear + 1).toString();
    }
    else {
      gradYearMapping["FE"] = (currentYear + 3).toString();
      gradYearMapping["SE"] = (currentYear + 2).toString();
      gradYearMapping["TE"] = (currentYear + 1).toString();
      gradYearMapping["BE"] = (currentYear).toString();
    }
  }
}

String calcGradYear(String? gradyear){

  // Check if gradyear is null or cannot be parsed to an integer
  if (gradyear == null || int.tryParse(gradyear) == null) {
    return "Invalid Graduation Year";
  }

  int graduationYear = int.parse(gradyear);

  // Get the current date and time
  DateTime now = DateTime.now();

  // Extract the current year
  int currentYear = now.year;

  // Extract the current month
  int currentMonth = now.month;

  // if current month is july onwads and gradyear is +4 more than the current year OR current month is before may and gradyear is +3 more thean the cuurent year then FE
  if( ((currentMonth>=7) && (graduationYear == currentYear+4)) || ((currentMonth<=6) && (graduationYear==currentYear+3)) ){
    return "FE";
  }
  else if( ((currentMonth>=7) && (graduationYear == currentYear+3)) || ((currentMonth<=6) && (graduationYear==currentYear+2)) ){
    return "SE";
  }
  else if( ((currentMonth>=7) && (graduationYear == currentYear+2)) || ((currentMonth<=6) && (graduationYear==currentYear+1)) ){
    return "TE";
  }
  else if( ((currentMonth>=7) && (graduationYear == currentYear+1)) || ((currentMonth<=6) && (graduationYear==currentYear)) ){
    return "BE";
  }
  else{
    return "Invalid Gradutation Year";
  }

}

List<String> calcBatchList(String? div, String? branch) {
  List<String> batches = [];
  if (div == null) {
    return batches;
  }
  if (branch == "Comps" || branch == "Extc"){
    for (int i = 1; i <= 4; i++) {
      batches.add("$div$i");
    }
  }
  else {
    for (int i = 1; i <= 3; i++) {
      batches.add("$div$i");
    }
  }
  return batches;
}

String evenOrOddSem() {
  int currentMonth = DateTime.now().month;

  // Check if the current month is between July (7) and December (12) inclusive
  if (currentMonth >= 7 && currentMonth <= 12) {
    return 'odd_sem';
  } else {
    return 'even_sem';
  }
}

// void main() {
//   MapsYear.mapGradYear();
// }