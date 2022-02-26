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
}
