import 'package:intl/intl.dart';

String getFormattedDateFromString(dynamic date) {
  if (date is String) {
    return DateFormat("yyyy-MM-dd").format(DateFormat().parseStrict(date));
  }
  if (date is DateTime) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
  throw ("Invalid Format provided in function");
}

DateTime getDateObjectFromString(String date) {
  return DateFormat("yyyy-MM-dd").parse(date);
}
