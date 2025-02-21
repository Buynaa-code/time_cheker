class DateInfo {
  final String date;
  final String day;

  DateInfo({required this.date, required this.day});

  factory DateInfo.fromString(String dateString) {
    List<String> parts = dateString.split(' - ');
    if (parts.length != 2) {
      throw FormatException("Invalid date format: $dateString");
    }
    return DateInfo(
      date: parts[0], // "01/01"
      day: parts[1], // "Лхагва"
    );
  }
}
