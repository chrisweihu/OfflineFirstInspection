import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime? dateTime) {
  if (dateTime == null) return '';
  return DateFormat('d MMM, yyyy').format(dateTime);
}
