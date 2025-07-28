import 'package:intl/intl.dart';

/// Extension methods for various Dart core types.
extension DateTimeExtension on DateTime {
  /// Formats a DateTime object into a short date string (e.g., "Jan 1, 2023").
  ///
  /// This is a common format for displaying dates without time.
  String toShortDate() {
    return DateFormat.yMMMd().format(this);
  }

  // You can add more DateTime extension methods here as needed,
  // for example, to format time, get difference, etc.
}

/// Extension methods for String.
extension StringExtension on String {
  /// Capitalizes the first letter of each word in the string.
  ///
  /// Example: "hello world" becomes "Hello World".
  String capitalizeEachWord() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Capitalizes only the first letter of the string.
  ///
  /// Example: "hello" becomes "Hello".
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Returns true if the string is null, empty, or contains only whitespace characters.
  bool get isBlank => trim().isEmpty;
}

// You can add more extension methods for other types here.
