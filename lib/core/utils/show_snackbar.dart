import 'package:flutter/material.dart';
import 'package:moodtune/core/themes/_themes.dart';

enum SnackbarStatus { success, error, warning, info }

SnackBar _customSnackbar({
  required String msg,
  required SnackbarStatus status,
}) {
  return SnackBar(
    content: Container(
      width: double.infinity,
      color: BaseColors.white,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: _generateIcon(status),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 24, 14),
              child: Text(
                msg,
                style: FontTheme.poppins12w500black(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    ),
    elevation: 3,
    duration: const Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.fromLTRB(42, 0, 42, 32),
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

Icon _generateIcon(SnackbarStatus status) {
  switch (status) {
    case SnackbarStatus.success:
      return const Icon(
        Icons.check_circle_outline_rounded,
        color: BaseColors.success,
      );
    case SnackbarStatus.error:
      return const Icon(Icons.error_rounded, color: BaseColors.error);
    case SnackbarStatus.warning:
      return const Icon(Icons.warning_rounded, color: BaseColors.warning);
    case SnackbarStatus.info:
      return const Icon(Icons.info_rounded, color: BaseColors.blue1);
  }
}

void showSuccessSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_customSnackbar(msg: msg, status: SnackbarStatus.success));
}

void showErrorSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_customSnackbar(msg: msg, status: SnackbarStatus.error));
}

void showWarningSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_customSnackbar(msg: msg, status: SnackbarStatus.warning));
}

void showInfoSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_customSnackbar(msg: msg, status: SnackbarStatus.info));
}
