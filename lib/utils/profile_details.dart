List<String> calcDivisionList(String gradyear, String branch) {
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
  // setState(() {
  //   divisionList = l;
  // });
  return l;
  // debugPrint(gradyear);
  // debugPrint(branch);
  // debugPrint(l.toString());
}

String calcGradYear(String gradyear) {
  if (gradyear == "2027") {
    return "First Year";
  } else if (gradyear == "2026") {
    return "Second Year";
  } else if (gradyear == "2025") {
    return "Third Year";
  } else {
    return "Final Year";
  }
}

List<String> calcBatchList(String? div) {
  List<String> batches = [];
  if (div == null) {
    // setState(() {
    //   batchList = batches;
    // });
    return batches;
  }
  for (int i = 1; i <= 3; i++) {
    batches.add("$div$i");
  }
  // return batches;
  // setState(() {
  //   batchList = batches;
  // });
  return batches;
}

Map<String, Map<String, List<String>>> subjects = {
  "TE": {
    "Aids": ["AI", "WCN", "STATS", "DWM"],
    "It": ["lkaksd", "sllsl"],
  },
  "BE": {
    "Aids": ["AI", "WCN", "STATS", "DWM"],
    "It": ["lkaksd", "sllsl"],
  }
};
