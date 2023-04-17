enum PlatformEnum {
  iOS,
  Android,
}

extension PlatformEnumExtension on PlatformEnum {
  String? get value {
    switch (this) {
      case PlatformEnum.iOS:
        return 'iOS';
      case PlatformEnum.Android:
        return 'Android';
      default:
        return null;
    }
  }
}
