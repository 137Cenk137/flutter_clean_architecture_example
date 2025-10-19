import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date).toString();
}

String formatDateBydMMMYYYY(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date).toLowerCase();
}
