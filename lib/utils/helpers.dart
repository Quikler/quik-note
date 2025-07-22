extension StringExtentions on String? {
  bool get isNullOrWhiteSpace {
    if (this == null) {
      return true;
    } else if (this?.isEmpty ?? true) {
      return true;
    } else if (this?.trim().isEmpty ?? true) {
      return true;
    }

    return false;
  }
}
