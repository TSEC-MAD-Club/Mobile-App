enum DepartmentEnum { aids, cs, it, biomed, biotech, chem, extc, fe }

const _departmentName = {
  DepartmentEnum.aids: "AI & DS",
  DepartmentEnum.biomed: "Biomedical Engineering",
  DepartmentEnum.biotech: "Bio-Tech Engineering",
  DepartmentEnum.chem: "Chemical Engineering",
  DepartmentEnum.cs: "Computer Engineering",
  DepartmentEnum.extc: "EXTC",
  DepartmentEnum.fe: "First Year",
  DepartmentEnum.it: "Information Technology",
};

extension GetDepartmentName on DepartmentEnum {
  String get getName {
    assert(
    DepartmentEnum.values.length == 8,
    "Add department name in the map as well",
    );

    return _departmentName[this]!;
  }
  String get fileName {
    switch (this) {
      case DepartmentEnum.aids:
        return "aids";
      case DepartmentEnum.cs:
        return "cs";
      case DepartmentEnum.it:
        return "it";
      case DepartmentEnum.biomed:
        return "biomed";
      case DepartmentEnum.biotech:
        return "biotech";
      case DepartmentEnum.chem:
        return "chemical";
      case DepartmentEnum.extc:
        return "extc";
      case DepartmentEnum.fe:
        return "fe";
    }
  }
}

