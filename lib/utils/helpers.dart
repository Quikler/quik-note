extension StringExtentions on String? {
  bool get isNullOrWhiteSpace => this?.trim().isEmpty ?? true;
}
