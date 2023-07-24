extension StringExtensions on String {
  bool isWhitespace() => trim().isEmpty;
  bool isValidDouble() => double.tryParse(this) != null;
  bool isValidInt() => int.tryParse(this) != null;
}
