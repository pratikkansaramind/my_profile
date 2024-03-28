class LoginState {
  final String email;
  final String password;
  final bool rememberMe;
  final bool showPassword;

  LoginState({
    required this.email,
    required this.password,
    required this.rememberMe,
    this.showPassword = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? showPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
        showPassword: showPassword ?? this.showPassword,
    );
  }
}

class LoginInitialState extends LoginState {
  LoginInitialState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class LoginSuccessState extends LoginState {
  LoginSuccessState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class LoginFailureState extends LoginState {
  LoginFailureState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class ValidEmailState extends LoginState {
  ValidEmailState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class ValidPasswordState extends LoginState {
  ValidPasswordState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class InvalidEmailState extends LoginState {
  final String error;

  InvalidEmailState({
    required this.error,
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class InvalidPasswordState extends LoginState {
  final String error;

  InvalidPasswordState({
    required this.error,
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class InvalidCredentialState extends LoginState {
  InvalidCredentialState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class UserLoggedInState extends LoginState {
  UserLoggedInState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}

class MoveToPasswordState extends LoginState {
  MoveToPasswordState({
    required super.email,
    required super.password,
    required super.rememberMe,
    required super.showPassword,
  });
}
