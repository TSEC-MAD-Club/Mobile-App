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

List<String> allYearList = ['FE', 'SE', 'TE', 'BE'];
List<String> allBranchList = ['Comps', 'It', 'Aids', 'Extc', "Chemical"];
Map<String, String> gradYear = {
  "FE": "2027",
  "SE": "2026",
  "TE": "2025",
  "BE": "2024",
};

String calcGradYear(String? gradyear) {
  if (gradyear == "2027") {
    return "FE";
  } else if (gradyear == "2026") {
    return "SE";
  } else if (gradyear == "2025") {
    return "TE";
  } else if (gradyear == "2024") {
    return "BE";
  } else {
    return "";
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

String evenOrOddSem() {
  int currentMonth = DateTime.now().month;

  // Check if the current month is between July (7) and December (12) inclusive
  if (currentMonth >= 7 && currentMonth <= 12) {
    return 'odd_sem';
  } else {
    return 'even_sem';
  }
}

Map<String, Map<String, Map<String, List<String>>>> subjects = {
  "FE": {
    "Aids": {
      "odd_sem": ["EM-1", "Phy-1", "Chem-1", "Mech", "BEE"],
      "even_sem": ["EM-2", "Phy-2", "Chem-2", "Graphics", "CP", "PCE-1"]
    },
    "Comps": {
      "odd_sem": ["EM-1", "Phy-1", "Chem-1", "Mech", "BEE"],
      "even_sem": ["EM-2", "Phy-2", "Chem-2", "Graphics", "CP", "PCE-1"]
    },
    "It": {
      "odd_sem": ["EM-1", "Phy-1", "Chem-1", "Mech", "BEE"],
      "even_sem": ["EM-2", "Phy-2", "Chem-2", "Graphics", "CP", "PCE-1"]
    },
    "Extc": {
      "odd_sem": ["EM-1", "Phy-1", "Chem-1", "Mech", "BEE"],
      "even_sem": ["EM-2", "Phy-2", "Chem-2", "Graphics", "CP", "PCE-1"]
    },
    "Chemical": {
      "odd_sem": ["EM-1", "Phy-1", "Chem-1", "Mech", "BEE"],
      "even_sem": ["EM-2", "Phy-2", "Chem-2", "Graphics", "CP", "PCE-1"]
    }
  },
  "SE": {
    "Aids": {
      "odd_sem": ["EM-3", "DSGT", "DS", "DLCA", "CG"],
      "even_sem": ["EM-4", "AOA", "DBMS", "OS", "MP"]
    },
    "Comps": {
      "odd_sem": ["EM-3", "DSGT", "DS", "DLCA", "CG"],
      "even_sem": ["EM-4", "AOA", "DBMS", "OS", "MP"]
    },
    "It": {
      "odd_sem": ["EM-3", "DSA", "DBMS", "POC", "PCPF"],
      "even_sem": ["EM-4", "CNN", "OS", "AT", "COA"]
    },
    "Extc": {
      "odd_sem": ["EM-3", "EDC", "DSD", "NT", "EICS"],
      "even_sem": ["EM-4", "MC", "LIC", "SS", "POCE"]
    },
    "Chemical": {
      "odd_sem": ["EM-3", "IEC-1", "FFO", "CET-1", "PC"],
      "even_sem": ["EM-4", "IEC-2", "NMCE", "SFMO", "CET-2"]
    }
  },
  "TE": {
    "Aids": {
      "odd_sem": ["CN", "WC", "AI", "DWM", "PCE-2", "SAIDS", "AA", "IOT"],
      "even_sem": ["DAV", "CSS", "SEPM", "ML", "HPC", "DC", "IVP"]
    },
    "Comps": {
      "odd_sem": ["TCS", "SE", "CN", "DWM", "PGM", "IP", "ADBMS", "PCE-2"],
      "even_sem": ["SPCC", "CSS", "MC", "AI", "IOT", "DSIP", "QA"]
    },
    "It": {
      "odd_sem": [
        "IP",
        "CNS",
        "EEB",
        "SE",
        "MEP",
        "ADBMS",
        "CGMS",
        "ADSA",
        "PCE-2"
      ],
      "even_sem": ["DMBI", "WEB", "WT", "AIDS-1", "SA", "IP", "GIT", "EHF"]
    },
    "Extc": {
      "odd_sem": [
        "DC",
        "DTSP",
        "DVLSI",
        "RSA",
        "PCE-2",
        "DIPTV",
        "DCC",
        "ITFS",
        "DSA",
        "ST"
      ],
      "even_sem": [
        "EMA",
        "CCN",
        "IPMV",
        "ANNFL",
        "MVLSI",
        "COA",
        "DF",
        "DBMS",
        "IOT",
        "RA"
      ]
    },
    "Chemical": {
      "odd_sem": ["MTO-1", "HTO", "CRE-1", "TP", "PCE-2", "FE", "AMS", "TQM"],
      "even_sem": ["MTO-1", "CRE-2", "PCT", "PEE", "PE", "PT", "IOM"]
    }
  },
  "BE": {
    "Aids": {
      "odd_sem": [
        "DL",
        "BDA",
        "NLP",
        "AIH",
        "NNFS",
        "UXVR",
        "BT",
        "GTDS",
        "PLM",
        "RE",
        "MIS",
        "DE",
        "OR",
        "CSL",
        "DMMM",
        "EAM",
        "DE"
      ],
      "even_sem": [
        "AAI",
        "AIFB",
        "QC",
        "RL",
        "GDS",
        "RS",
        "SMA",
        "PM",
        "FM",
        "EDM",
        "HRM",
        "PCE-CSR",
        "RM",
        "IPRP",
        "DBM",
        "EVM"
      ]
    },
    "Comps": {
      "odd_sem": [
        "ML",
        "BDA",
        "MV",
        "QC",
        "NLP",
        "AVR",
        "BC",
        "IR",
        "PLM",
        "RE",
        "MIS",
        "DE",
        "DE",
        "OR",
        "CRL",
        "DMMM",
        "EAM",
        "DEE"
      ],
      "even_sem": [
        "HMI",
        "DC",
        "HPC",
        "NLP",
        "AWN",
        "PM",
        "FM",
        "EDM",
        "HRM",
        "PCE-CSR",
        "RM",
        "IPRP",
        "DBM",
        "EVM"
      ]
    },
    "It": {
      "odd_sem": [
        "AIDS-2,",
        "IOT",
        "SAN",
        "HPC",
        "IS",
        "STQA",
        "MANET",
        "AR-VR",
        "QC",
        "IRS",
        "PLM",
        "RE",
        "MES",
        "DE",
        "OR",
        "CRS",
        "DMMM",
        "EAM",
        "DE"
      ],
      "even_sem": [
        "BDA",
        "IOT",
        "UID",
        "IRS",
        "KM",
        "RoBo",
        "ERP",
        "PM",
        "FM",
        "EDM",
        "HRM",
        "PCE-CSR",
        "RM",
        "IPRP",
        "DBM",
        "EVM"
      ]
    },
    "Extc": {
      "odd_sem": [
        "ME",
        "MCS",
        "EADSPA",
        "DL",
        "BDA",
        "CCS",
        "SDR",
        "RoBo",
        "5GT",
        "ICE",
        "ADSP",
        "QC",
        "PLM",
        "RE",
        "MIS",
        "DE",
        "OR",
        "CSL",
        "DMMM",
        "EAM",
        "DE"
      ],
      "even_sem": [
        "RFD",
        "WN",
        "PN",
        "ADSP",
        "SC",
        "NMT",
        "PM",
        "FM",
        "EDM",
        "HRM",
        "PCE-CSR",
        "IPRP",
        "DBM",
        "EM"
      ]
    },
    "Chemical": {
      "odd_sem": [
        "IPDC",
        "CEED",
        "CE",
        "FCIST",
        "PMCPI",
        "CPSH",
        "PRT",
        "OR",
        "PLM",
        "DE",
        "DMMM",
        "RE",
        "OR",
        "EAM",
        "MIS",
        "CSL",
        "DE"
      ],
      "even_sem": [
        "MSO",
        "ESD",
        "AST",
        "FM",
        "FCEE",
        "Bio",
        "Nano",
        "CWM",
        "PM",
        "FM",
        "HRM",
        "PCE-CSR",
        "IPRP",
        "DBM"
      ]
    }
  }
};
