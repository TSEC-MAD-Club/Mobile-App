enum DepartmentEnum {
  aids,
  cs,
  it,
  chem,
  extc,
  fe;

  String get name {
    switch (this) {
      case DepartmentEnum.aids:
        return "AI & DS";
      case DepartmentEnum.cs:
        return "Computer Engineering";
      case DepartmentEnum.it:
        return "Information Technology";
      case DepartmentEnum.chem:
        return "Chemical Engineering";
      case DepartmentEnum.extc:
        return "EXTC";
      case DepartmentEnum.fe:
        return "First Year";
    }
  }

  String get fileName {
    switch (this) {
      case DepartmentEnum.aids:
        return "aids";
      case DepartmentEnum.cs:
        return "cs";
      case DepartmentEnum.it:
        return "it";
      case DepartmentEnum.chem:
        return "chemical";
      case DepartmentEnum.extc:
        return "extc";
      case DepartmentEnum.fe:
        return "fe";
    }
  }
}
