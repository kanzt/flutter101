enum DepartmentEnum {
  ALL,
  PC,
  NETWORK,
  SE,
}

extension DepartmentExtension on DepartmentEnum {

  String? get fullText {
    switch (this) {
      case DepartmentEnum.ALL:
        return 'All';
      case DepartmentEnum.PC:
        return 'PC';
      case DepartmentEnum.NETWORK:
        return 'Network';
      case DepartmentEnum.SE:
        return 'SE';
      default:
        return null;
    }
  }

  String? get code {
    switch (this) {
      case DepartmentEnum.ALL:
        return null;
      case DepartmentEnum.PC:
        return 'PC';
      case DepartmentEnum.NETWORK:
        return 'NET';
      case DepartmentEnum.SE:
        return 'SE';
      default:
        return null;
    }
  }
}