import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/presentation/blocs/login/login_event.dart';
import 'package:my_profile/src/presentation/blocs/login/login_state.dart';
import 'package:my_profile/src/utils/validators/email_validator.dart';
import 'package:my_profile/src/utils/validators/password_validator.dart';

@singleton
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(LoginInitialState(
          email: '',
          password: '',
          rememberMe: false,
          showPassword: false,
        )) {
    on<ValidateEmailEvent>(_validateEmail);
    on<ValidatePasswordEvent>(_validatePassword);
    on<UpdateRememberMeEvent>(_updateRememberMe);
    on<LoginUserEvent>(_loginUser);
    on<ShowPasswordEvent>(_showPassword);
    on<MoveToPasswordEvent>(_moveToPassword);
  }

  void _moveToPassword(MoveToPasswordEvent event, Emitter<LoginState> emit) {
    UserDetailsModel? userDetailsModel =
        hiveDataServiceRepo.fetchUser(email: state.email);

    emit(MoveToPasswordState(
      email: state.email,
      password: state.password,
      rememberMe: userDetailsModel?.rememberMe ?? state.rememberMe,
      showPassword: state.showPassword,
    ));
  }

  void _validateEmail(ValidateEmailEvent event, Emitter<LoginState> emit) {
    final email = event.email.trim();

    if (email.isNotEmpty) {
      if (EmailValidator.isValid(email)) {
        emit(ValidEmailState(
          email: email,
          password: state.password,
          rememberMe: state.rememberMe,
          showPassword: state.showPassword,
        ));

        if (event.moveToPassword) {
          add(MoveToPasswordEvent());
        }
      } else {
        emit(InvalidEmailState(
          error: 'Please enter valid email address.',
          email: email,
          password: state.password,
          rememberMe: state.rememberMe,
          showPassword: state.showPassword,
        ));
      }
    } else {
      emit(InvalidEmailState(
        error: 'Please enter email address.',
        email: email,
        password: state.password,
        rememberMe: state.rememberMe,
        showPassword: state.showPassword,
      ));
    }
  }

  void _validatePassword(
      ValidatePasswordEvent event, Emitter<LoginState> emit) {
    final password = event.password.trim();

    if (password.isNotEmpty) {
      if (PasswordValidator.isValid(password)) {
        emit(ValidPasswordState(
          email: state.email,
          password: password,
          rememberMe: state.rememberMe,
          showPassword: state.showPassword,
        ));
        add(LoginUserEvent());
      } else {
        emit(InvalidPasswordState(
          error: '''
Password must contain:
- At least 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one digit
- At least one special character (!@#\$&*~)
    ''',
          email: state.email,
          password: password,
          rememberMe: state.rememberMe,
          showPassword: state.showPassword,
        ));
      }
    } else {
      emit(InvalidPasswordState(
        error: 'Please enter password.',
        email: state.email,
        password: password,
        rememberMe: state.rememberMe,
        showPassword: state.showPassword,
      ));
    }
  }

  void _updateRememberMe(
      UpdateRememberMeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(rememberMe: event.rememberMe));
  }

  Future<void> _loginUser(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    final email = state.email;
    final password = state.password;

    UserDetailsModel? userDetailsModel =
        hiveDataServiceRepo.fetchUser(email: email);

    if (userDetailsModel != null) {
      if (password == userDetailsModel.password) {
        userDetailsModel = userDetailsModel.copyWith(
          isLoggedIn: true,
          rememberMe: state.rememberMe,
        );

        await hiveDataServiceRepo
            .createOrUpdateUser(userDetailsModel)
            .whenComplete(() {
          emit(LoginSuccessState(
            email: email,
            password: password,
            rememberMe: state.rememberMe,
            showPassword: state.showPassword,
          ));
        });

        add(UpdateRememberMeEvent(rememberMe: false));
        add(ShowPasswordEvent(show: false));
      } else {
        emit(InvalidCredentialState(
          email: email,
          password: password,
          rememberMe: state.rememberMe,
          showPassword: state.showPassword,
        ));
      }
    } else {
      final userDetailsModel = UserDetailsModel(
        email: email,
        password: password,
        image: '',
        name: '',
        skills: [],
        workExp: [],
        isLoggedIn: true,
        rememberMe: state.rememberMe,
      );

      await hiveDataServiceRepo
          .createOrUpdateUser(userDetailsModel)
          .whenComplete(() {
        emit(LoginSuccessState(
          email: email,
          password: password,
          rememberMe: state.rememberMe,
          showPassword: state.showPassword,
        ));

        emit(LoginInitialState(
          email: '',
          password: '',
          rememberMe: false,
          showPassword: state.showPassword,
        ));

        add(UpdateRememberMeEvent(rememberMe: false));
        add(ShowPasswordEvent(show: false));
      });
    }
  }

  void _showPassword(ShowPasswordEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState(
      email: state.email,
      password: state.password,
      rememberMe: state.rememberMe,
      showPassword: event.show,
    ));
  }
}
