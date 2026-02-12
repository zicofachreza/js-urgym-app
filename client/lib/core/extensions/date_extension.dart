import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// dd MMM yyyy • HH:mm
  String toReadableDateTime() {
    return DateFormat('dd MMM yyyy • HH:mm').format(toLocal());
  }

  /// dd MMM yyyy
  String toReadableDate() {
    return DateFormat('dd MMM yyyy').format(toLocal());
  }

  /// HH:mm
  String toTime() {
    return DateFormat('HH:mm').format(toLocal());
  }
}
