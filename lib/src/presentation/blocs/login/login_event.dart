abstract class LoginEvent {}

class ValidateEmailEvent extends LoginEvent {
  final String email;
  final bool moveToPassword;

  ValidateEmailEvent({
    required this.email,
    required this.moveToPassword,
  });
}

class ValidatePasswordEvent extends LoginEvent {
  final String password;

  ValidatePasswordEvent({required this.password});
}

class UpdateRememberMeEvent extends LoginEvent {
  final bool rememberMe;

  UpdateRememberMeEvent({required this.rememberMe});
}

class LoginUserEvent extends LoginEvent {}

class ShowPasswordEvent extends LoginEvent {
  final bool show;

  ShowPasswordEvent({required this.show});
}

class MoveToPasswordEvent extends LoginEvent {}
