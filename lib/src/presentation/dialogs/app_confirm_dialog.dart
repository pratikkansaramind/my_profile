import 'package:flutter/material.dart';

/// [AppConfirmDialog] is used to show confirm or alert dialog
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String positiveText;
  final String? negativeText;
  final VoidCallback? onPositiveTap;
  final VoidCallback? onNegativeTap;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.positiveText,
    this.negativeText,
    this.onPositiveTap,
    this.onNegativeTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        subtitle,
      ),
      actions: [
        if (negativeText != null)
          TextButton(
            onPressed: onNegativeTap,
            child: Text(
              negativeText!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color.fromRGBO(24, 32, 47, 1),
                  ),
            ),
          ),
        TextButton(
          onPressed: onPositiveTap,
          child: Text(
            positiveText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color.fromRGBO(24, 32, 47, 1),
                ),
          ),
        ),
      ],
    );
  }
}
