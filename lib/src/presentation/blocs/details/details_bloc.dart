import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';
import 'package:my_profile/src/presentation/blocs/details/details_event.dart';
import 'package:my_profile/src/presentation/blocs/details/details_state.dart';

@injectable
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc()
      : super(InitialDetailsState(
            userDetailsModel: hiveDataServiceRepo.fetchLoggedInUser())) {
    on<UpdateNameEvent>(_updateName);
    on<UserSkillEvent>(_userSkill);
    on<UpdateSkillEvent>(_updateSkill);
    on<UpdateWorkExpEvent>(_updateWorkExp);
    on<DeleteWorkExpEvent>(_deleteWorkExp);
    on<CheckMediaPermissionEvent>(_checkMediaPermission);
    on<ChangeUserEvent>(_changeUser);
    on<LogoutEvent>(_logout);
  }

  Future<void> _logout(LogoutEvent event, Emitter<DetailsState> emit) async {
    await hiveDataServiceRepo
        .createOrUpdateUser(state.userDetailsModel.copyWith(isLoggedIn: false))
        .whenComplete(() {
      emit(LogoutState(userDetailsModel: state.userDetailsModel));
    });
  }

  void _changeUser(ChangeUserEvent event, Emitter<DetailsState> emit) {
    emit(InitialDetailsState(userDetailsModel: event.userDetailsModel));
  }

  Future<void> _updateName(
      UpdateNameEvent event, Emitter<DetailsState> emit) async {
    final name = event.name;

    final userDetailsModel = state.userDetailsModel.copyWith(
      name: name,
    );

    await hiveDataServiceRepo.createOrUpdateUser(userDetailsModel).whenComplete(() {
      emit(UpdateNameState(
        userDetailsModel: userDetailsModel,
      ));
    });
  }

  void _userSkill(UserSkillEvent event, Emitter<DetailsState> emit) {
    emit(UserSkillState(list: event.list));
    emit(InitialDetailsState(userDetailsModel: state.userDetailsModel));
  }

  Future<void> _updateSkill(
      UpdateSkillEvent event, Emitter<DetailsState> emit) async {
    final userDetailsModel = state.userDetailsModel.copyWith(
      skills: event.list,
    );

    await hiveDataServiceRepo.createOrUpdateUser(userDetailsModel).whenComplete(() {
      emit(UpdateSkillState(
        userDetailsModel: userDetailsModel,
      ));
    });
  }

  Future<void> _updateWorkExp(
      UpdateWorkExpEvent event, Emitter<DetailsState> emit) async {
    List<WorkExpModel> list = state.userDetailsModel.workExp;

    if (event.isUpdate) {
      list.removeWhere((element) => element.id == event.model.id);
    }

    list.add(event.model);

    final userDetailsModel = state.userDetailsModel.copyWith(
      workExp: list,
    );

    await hiveDataServiceRepo.createOrUpdateUser(userDetailsModel).whenComplete(() {
      emit(InitialDetailsState(
        userDetailsModel: userDetailsModel,
      ));
    });
  }

  Future<void> _deleteWorkExp(
      DeleteWorkExpEvent event, Emitter<DetailsState> emit) async {
    List<WorkExpModel> list = state.userDetailsModel.workExp;
    list.removeWhere((element) => element.id == event.model.id);

    final userDetailsModel = state.userDetailsModel.copyWith(
      workExp: list,
    );

    await hiveDataServiceRepo.createOrUpdateUser(userDetailsModel).whenComplete(() {
      emit(InitialDetailsState(
        userDetailsModel: userDetailsModel,
      ));
    });
  }

  Future<void> _checkMediaPermission(
      CheckMediaPermissionEvent event, Emitter<DetailsState> emit) async {
    final ImagePicker picker = ImagePicker();

    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 60)
        .then((value) async {
      if (value != null) {
        final String image = base64Encode(
          await value.readAsBytes(),
        );

        final userDetailsModel = state.userDetailsModel.copyWith(
          image: image,
        );

        await hiveDataServiceRepo
            .createOrUpdateUser(userDetailsModel)
            .whenComplete(() {
          emit(UpdateImageState(userDetailsModel: userDetailsModel));
        });
      }
    }).whenComplete(() {});
  }
}
