import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/config/router/app_router.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/presentation/blocs/login/login_bloc.dart';
import 'package:my_profile/src/presentation/blocs/login/login_event.dart';
import 'package:my_profile/src/presentation/blocs/login/login_state.dart';
import 'package:my_profile/src/presentation/dialogs/remember_me_view.dart';
import 'package:my_profile/src/presentation/widgets/label_section.dart';
import 'package:my_profile/src/presentation/widgets/section_animation_screen.dart';
import 'package:my_profile/src/presentation/widgets/user_detail_section.dart';
import 'package:my_profile/src/utils/constants/app_assets.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();

  final _emailFocusNode = FocusNode();

  final Duration _duration = const Duration(milliseconds: 250);

  late AnimationController _imageFadeAnimController;
  late AnimationController _mobileSection1FadeAnimController;
  late AnimationController _mobileSection2FadeAnimController;
  late AnimationController _otpSectionFadeAnimController;
  late AnimationController _userMobileFadeAnimController;
  late AnimationController _mobileSection1SlideUpAnimController;

  late Animation<double> _imageFadeAnim;
  late Animation<double> _mobileSection1FadeAnim;
  late Animation<double> _mobileSection2FadeAnim;
  late Animation<double> _otpSectionFadeAnim;
  late Animation<double> _userMobileFadeAnim;
  late Animation<double> _mobileSection1SlideUpAnim;

  @override
  void initState() {
    super.initState();
    _initAnimController();
    _initFadeAnim();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _forwardAnim(_imageFadeAnimController);
      _forwardAnim(_mobileSection1FadeAnimController);
      _forwardAnim(_mobileSection2FadeAnimController);
    });
  }

  @override
  Widget build(BuildContext context) {
    _initSlideUpAnim();

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            AutoRouter.of(context).pushAndPopUntil(const UserDetailsRoute(),
                predicate: (route) => false);
          } else if (state is InvalidCredentialState) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter valid password.')));
          } else if (state is MoveToPasswordState) {
            _forwardAnim(_mobileSection1SlideUpAnimController);
            _forwardAnim(_mobileSection2FadeAnimController);
            _forwardAnim(_userMobileFadeAnimController);
            _forwardAnim(_otpSectionFadeAnimController);

            _reverseAnim(_mobileSection2FadeAnimController);
            _reverseAnim(_imageFadeAnimController);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).longestSide,
            padding: EdgeInsets.all(16.pixelScale(context)),
            child: Stack(
              children: [
                _image,
                _email,
                _userEmail,
                _password,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _image => Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.sizeOf(context).longestSide / 2,
        margin: EdgeInsets.only(
          top: AppBar().preferredSize.height,
        ),
        child: FadeTransition(
          opacity: _imageFadeAnim,
          child: Visibility(
            visible: _imageFadeAnim.value != 0,
            child: Image.asset(
              AppAssets.imgAppIcon,
              height: MediaQuery.sizeOf(context).longestSide / 6,
            ),
          ),
        ),
      );

  Widget get _email => Container(
        height: MediaQuery.sizeOf(context).longestSide,
        alignment: Alignment.bottomCenter,
        child: SectionAnimationScreen(
          section1SlideUpAnimation: _mobileSection1SlideUpAnim,
          section1FadeAnimation: _mobileSection1FadeAnim,
          section2FadeAnimation: _mobileSection2FadeAnim,
          section1: LabelSection(
            animation: _mobileSection1SlideUpAnim,
            label1: 'What\'s your\nemail address?',
            label2: 'We need to verify',
          ),
          section2: Stack(
            children: [
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) {
                  bool result = current is InvalidEmailState ||
                      current is ValidEmailState;
                  return result;
                },
                builder: (context, state) {
                  return TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      loginBloc.add(ValidateEmailEvent(
                        email: _emailController.text,
                        moveToPassword: true,
                      ));
                    },
                    onTap: () async {
                      final users = hiveDataServiceRepo.fetchRememberMeUsers();
                      if (users.isNotEmpty &&
                          _emailController.text.trim().isEmpty) {
                        UserDetailsModel? model =
                            await showModalBottomSheet<UserDetailsModel>(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: RememberMePage(
                                users: users,
                              ),
                            );
                          },
                        );

                        if (model != null) {
                          _emailController.text = model.email;
                          _pwdController.text = model.password;

                          loginBloc.add(UpdateRememberMeEvent(
                              rememberMe: model.rememberMe));
                          loginBloc.add(ValidateEmailEvent(
                            email: model.email,
                            moveToPassword: true,
                          ));
                        }
                      }
                    },
                    onChanged: (value) {
                      _pwdController.clear();
                      if (state is InvalidEmailState) {
                        loginBloc.add(ValidateEmailEvent(
                          email: value,
                          moveToPassword: false,
                        ));
                      }
                    },
                    autovalidateMode: state is InvalidEmailState
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      hintText: 'abc@xyz.com',
                      errorText:
                          state is InvalidEmailState ? state.error : null,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 65),
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    loginBloc.add(ValidateEmailEvent(
                      email: _emailController.text,
                      moveToPassword: true,
                    ));
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget get _userEmail => SizedBox(
        height: MediaQuery.sizeOf(context).longestSide / 2,
        child: UserDetailSection(
          animation: _userMobileFadeAnim,
          margin: EdgeInsets.only(top: 120.pixelScale(context)),
          label: _emailController.text,
          msg: '',
          extraMsg: '',
          moveToPrevious: () {
            _forwardAnim(_mobileSection1FadeAnimController);
            _forwardAnim(_mobileSection2FadeAnimController);
            _forwardAnim(_userMobileFadeAnimController);
            _forwardAnim(_imageFadeAnimController);

            _reverseAnim(_userMobileFadeAnimController);
            _reverseAnim(_mobileSection1SlideUpAnimController);
            _reverseAnim(_otpSectionFadeAnimController);
          },
        ),
      );

  Widget get _password => Container(
        height: MediaQuery.sizeOf(context).longestSide,
        alignment: Alignment.bottomCenter,
        child: FadeTransition(
          opacity: _otpSectionFadeAnim,
          child: Visibility(
            visible: _otpSectionFadeAnim.value != 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s your\npassword?',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 30.pixelScale(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                Text(
                  'New users can set a new password here, while existing users must enter their original password when logging in for the first time to verify themselves.',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.grey,
                      ),
                ),
                SizedBox(
                  height: 10.pixelScale(context),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) {
                    return current is InvalidPasswordState ||
                        current is ValidPasswordState ||
                        current is LoginInitialState;
                  },
                  builder: (context, state) {
                    return TextFormField(
                      controller: _pwdController,
                      obscureText: !state.showPassword,
                      onChanged: (value) {
                        if (state is InvalidPasswordState) {
                          loginBloc.add(ValidatePasswordEvent(password: value));
                        }
                      },
                      onFieldSubmitted: (value) {
                        loginBloc.add(ValidatePasswordEvent(
                            password: _pwdController.text));
                      },
                      autovalidateMode: state is InvalidEmailState
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        errorText:
                            state is InvalidPasswordState ? state.error : null,
                        suffixIcon: IconButton(
                          onPressed: () {
                            loginBloc.add(
                                ShowPasswordEvent(show: !state.showPassword));
                          },
                          icon: SvgPicture.asset(
                            !state.showPassword
                                ? AppAssets.icEyeOpen
                                : AppAssets.icEyeClose,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _rememberMe,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      loginBloc.add(
                          ValidatePasswordEvent(password: _pwdController.text));
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget get _rememberMe => BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return CheckboxListTile(
            value: state.rememberMe,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Remember Me'),
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              loginBloc.add(UpdateRememberMeEvent(
                rememberMe: value ?? state.rememberMe,
              ));
            },
          );
        },
      );

  void _initAnimController() {
    _imageFadeAnimController = _getAnimController();
    _mobileSection1FadeAnimController = _getAnimController();
    _mobileSection2FadeAnimController = _getAnimController();
    _mobileSection1SlideUpAnimController = _getAnimController();
    _userMobileFadeAnimController = _getAnimController();
    _otpSectionFadeAnimController = _getAnimController();
  }

  void _initFadeAnim() {
    _imageFadeAnim = _getFadeAnim(_imageFadeAnimController);
    _mobileSection1FadeAnim = _getFadeAnim(_mobileSection1FadeAnimController);
    _mobileSection2FadeAnim = _getFadeAnim(_mobileSection2FadeAnimController);
    _userMobileFadeAnim = _getFadeAnim(_userMobileFadeAnimController);
    _otpSectionFadeAnim = _getFadeAnim(_otpSectionFadeAnimController);
  }

  void _initSlideUpAnim() {
    _mobileSection1SlideUpAnim = _getSlideUpAnim(
        _mobileSection1SlideUpAnimController,
        MediaQuery.of(context).size.height);
  }

  void _forwardAnim(AnimationController controller) {
    controller.forward();
  }

  void _reverseAnim(AnimationController controller) {
    controller.reverse();
  }

  AnimationController _getAnimController() {
    return AnimationController(vsync: this, duration: _duration);
  }

  Animation<double> _getFadeAnim(AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Animation<double> _getSlideUpAnim(
    AnimationController controller,
    double end,
  ) {
    return Tween<double>(begin: 0, end: -end).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }
}
