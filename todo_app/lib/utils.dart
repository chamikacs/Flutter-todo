import 'package:intl/intl.dart';

class Utils {
  String formatDate(DateTime? date) {
    return date != null ? DateFormat('dd MMMM yyyy').format(date) : 'N/A';
  }
}
