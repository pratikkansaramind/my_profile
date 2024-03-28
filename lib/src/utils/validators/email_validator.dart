class EmailValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );

  static bool isValid(String email) {
    return _emailRegex.hasMatch(email);
  }
}