class PasswordValidator {
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$',
    caseSensitive: true,
    multiLine: false,
  );

  static bool isValid(String password) {
    return _passwordRegex.hasMatch(password);
  }
}