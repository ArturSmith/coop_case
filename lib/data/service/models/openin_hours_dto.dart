class OpeningHoursDto {
  final String day;
  final String timeText;

  OpeningHoursDto({required this.day, required this.timeText});

  factory OpeningHoursDto.fromJson(Map<String, dynamic> json) {
    const daysMap = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };

    final dayNum = json['dayOfWeek'] as int?;
    final day = daysMap[dayNum ?? 0] ?? 'Unknown';

    final from = json['from1'] as String?;
    final to = json['to1'] as String?;
    final isCLosed = (json['closed'] as bool?) ?? false;

    final finalTimeText =
        isCLosed || from == null || to == null ? "Closed" : "$from-$to";

    return OpeningHoursDto(day: day, timeText: finalTimeText);
  }
}
