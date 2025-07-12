import 'package:flutter/material.dart';

import '../../themes/_themes.dart';

class TextInputDecorator {
  TextInputDecorator() {
    _inputDecoration = const InputDecoration();
  }

  late InputDecoration _inputDecoration;

  InputDecoration defaultDecoration() {
    return _inputDecoration.copyWith();
  }

  static InputDecoration form(
    String labelText,
    String hint, {
    Widget? suffixIcon,
    bool isRequired = false,
  }) {
    return InputDecoration(
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: FontTheme.poppins24w500black().copyWith(
        color: BaseColors.purpleHearth,
      ),
      border: InputBorder.none,
    );
  }

  static InputDecoration search({
    required BuildContext context,
    String? hint,
    TextStyle? hintStyle,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) {
    return InputDecoration(
      prefixIcon: const Icon(
        Icons.search,
        color: BaseColors.purpleHearth,
      ),
      hintText: hint ?? 'Search',
      hintStyle: hintStyle ??
          FontTheme.poppins12w500black().copyWith(
            color: BaseColors.gray2,
          ),
      filled: true,
      fillColor: color ?? BaseColors.white,
      contentPadding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: BaseColors.purpleHearth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: BaseColors.gray3,
        ),
      ),
    );
  }
}
