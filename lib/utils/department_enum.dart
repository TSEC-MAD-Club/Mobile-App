enum DepartmentEnum {
  aids,
  cs,
  it,
  biomed,
  biotech,
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
      case DepartmentEnum.biomed:
        return "Biomedical Engineering";
      case DepartmentEnum.biotech:
        return "Bio-Tech Engineering";
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