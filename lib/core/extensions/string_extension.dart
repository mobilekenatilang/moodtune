part of '_extensions.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
