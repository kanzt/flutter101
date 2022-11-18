enum AvailableSize {
  us6,
  us7,
  us8,
  us9,
}

extension AvailableSizeExtension on AvailableSize {
  String get size {
    switch (this) {
      case AvailableSize.us6:
        return 'US 6';
      case AvailableSize.us7:
        return 'US 7';
      case AvailableSize.us8:
        return 'US 8';
      case AvailableSize.us9:
        return 'US 9';
      default:
        return '';
    }
  }
}