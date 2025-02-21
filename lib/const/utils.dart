String getQuarterFromDate(DateTime? date) {
  if (date == null) return '';
  try {
    final quarter = ((date.month - 1) ~/ 3) + 1;
    return '$quarter-р улирал';
  } catch (e) {
    return '';
  }
}

String formatDate(DateTime? date) {
  if (date == null) return '';
  try {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return '';
  }
}

String formatDateTime(DateTime? date) {
  if (date == null) return '';
  try {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return '';
  }
}

String formatTime(DateTime? date) {
  if (date == null) return '';
  try {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return '';
  }
} 

String formatNumber(String? number) {
  if (number == null) return '';
  try {
    return number.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  } catch (e) {
    return '';
  }
}