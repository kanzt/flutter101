extension BooleanAdapterToStringExtension on bool
{
  String get booleanToString {
    switch (this) {
      case true:
    return "true";
    case false:
    return "false";
    default:
    return "false";
    }
    }
}
extension StringAdapterToBooleanExtension on String{
  bool get stringToBoolean {
    switch (this) {
      case "true":
        return true;
      case "false":
        return false;
      default:
        return false;
    }
  }
}