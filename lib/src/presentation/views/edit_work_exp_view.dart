import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';
import 'package:my_profile/src/presentation/blocs/details/details_bloc.dart';
import 'package:my_profile/src/presentation/blocs/details/details_event.dart';
import 'package:my_profile/src/presentation/blocs/details/details_state.dart';
import 'package:my_profile/src/presentation/dialogs/app_confirm_dialog.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

@RoutePage()
class EditWorkExpPage extends StatefulWidget {
  final WorkExpModel? workExpModel;

  const EditWorkExpPage({
    super.key,
    this.workExpModel,
  });

  @override
  State<EditWorkExpPage> createState() => _EditWorkExpPageState();
}

class _EditWorkExpPageState extends State<EditWorkExpPage> {
  final _companyNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _yearController = TextEditingController();

  bool _update = false;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _update = widget.workExpModel != null;

    if (_update) {
      _companyNameController.text = widget.workExpModel!.companyName;
      _designationController.text = widget.workExpModel!.jobTitle;
      _yearController.text = widget.workExpModel!.years.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Work Experience',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          onPressed: () {
            _onWillPop().then((value) {
              if (value) {
                AutoRouter.of(context).maybePop();
              }
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          return Form(
            key: _key,
            onWillPop: () {
              if (state is InitialDetailsState) {
                return Future.value(true);
              }

              return _onWillPop();
            },
            child: Container(
              padding: EdgeInsets.all(16.pixelScale(context)),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Name*',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        TextFormField(
                          controller: _companyNameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Enter Company Name',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Designation*',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        TextFormField(
                          controller: _designationController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Enter Designation',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Years of Experience*',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        TextFormField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            _onSave();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Years of Experience',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: Text(
                        _update ? 'Update' : 'Save',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void deactivate() {
    _companyNameController.dispose();
    _designationController.dispose();
    _yearController.dispose();
    super.deactivate();
  }

  Future<bool> _onWillPop() async {
    /// Check if data have been updated
    if (_update &&
        (widget.workExpModel!.companyName !=
                _companyNameController.text.trim() ||
            widget.workExpModel!.jobTitle !=
                _designationController.text.trim() ||
            widget.workExpModel!.years.toString() !=
                _yearController.text.trim())) {
      /// Show a confirmation dialog
      bool confirm = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AppConfirmDialog(
            title: 'Warning',
            subtitle: 'Are you sure, you want to discard the changes?',
            positiveText: 'Cancel',
            negativeText: 'Discard',
            onPositiveTap: () {
              AutoRouter.of(context).maybePop(false);
            },
            onNegativeTap: () {
              AutoRouter.of(context).maybePop(true);
            },
          );
        },
      );

      /// Return the user's choice
      return confirm;
    }

    /// If data are not updated, allow navigation back
    return true;
  }

  void _onSave() {
    if (_companyNameController.text.trim().isNotEmpty &&
        _designationController.text.trim().isNotEmpty &&
        _yearController.text.trim().isNotEmpty) {
      List<WorkExpModel> list = hiveDataServiceRepo.fetchLoggedInUser().workExp;

      int id = 1;

      if (list.isNotEmpty) {
        WorkExpModel workExpModel = list.reduce(
            (value, element) => value.id > element.id ? value : element);
        id = workExpModel.id + 1;
      }

      WorkExpModel model = WorkExpModel(
        companyName: _companyNameController.text.trim(),
        jobTitle: _designationController.text.trim(),
        years: int.parse(_yearController.text.trim()),
        id: _update ? widget.workExpModel!.id : id,
      );

      detailsBloc.add(UpdateWorkExpEvent(
        model: model,
        isUpdate: _update,
      ));

      AutoRouter.of(context).maybePop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all details.',
          ),
        ),
      );
    }
  }
}
