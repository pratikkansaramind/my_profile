import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/presentation/blocs/details/details_bloc.dart';
import 'package:my_profile/src/presentation/blocs/details/details_event.dart';
import 'package:my_profile/src/presentation/blocs/details/details_state.dart';
import 'package:my_profile/src/presentation/dialogs/app_confirm_dialog.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

@RoutePage()
class EditNamePage extends StatefulWidget {
  final String name;

  const EditNamePage({
    super.key,
    required this.name,
  });

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Name',
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
      body: BlocConsumer<DetailsBloc, DetailsState>(
        listener: (context, state) {
          if (state is UpdateNameState) {
            AutoRouter.of(context).maybePop();
          }
        },
        builder: (context, state) {
          return Form(
            onWillPop: () {
              if (widget.name.trim().isEmpty ||
                  state is UpdateNameState ||
                  state is InitialDetailsState) {
                return Future.value(true);
              }

              return _onWillPop();
            },
            child: Container(
              padding: EdgeInsets.all(16.pixelScale(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      onFieldSubmitted: (value) {
                        _onSave();
                      },
                      decoration: const InputDecoration(
                          hintText: 'Enter your name here'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: Text(
                        'Save',
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
    _nameController.dispose();
    super.deactivate();
  }

  Future<bool> _onWillPop() async {
    /// Check if data have been updated
    if (widget.name != _nameController.text.trim()) {
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
    if (_nameController.text.trim().isNotEmpty) {
      detailsBloc.add(UpdateNameEvent(name: _nameController.text));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter name.',
          ),
        ),
      );
    }
  }
}
