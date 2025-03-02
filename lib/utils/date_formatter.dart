import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String formatDate(DateTime date, BuildContext context) {
  final t = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final difference = now.difference(date);
  
  if (difference.inSeconds < 60) {
    return t.timeJustNow;
  }
  
  if (difference.inMinutes < 60) {
    return t.timeMinutesAgo(difference.inMinutes);
  }
  
  if (difference.inHours < 24) {
    return t.timeHoursAgo(difference.inHours);
  }
  
  if (difference.inDays < 30) {
    return t.timeDaysAgo(difference.inDays);
  }
  
  final months = (difference.inDays / 30).floor();
  if (months < 12) {
    return t.timeMonthsAgo(months);
  }
  
  final years = (difference.inDays / 365).floor();
  return t.timeYearsAgo(years);
}

DateTime parseDate(String date) {
  if (date.isEmpty) {
    throw FormatException('Date string cannot be empty');
  }
  
  final parts = date.split("/");
  if (parts.length != 3) {
    throw FormatException('Invalid date format. Expected dd/mm/yyyy');
  }

  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) {
    throw FormatException('Invalid date components');
  }

  if (month < 1 || month > 12) {
    throw FormatException('Invalid month: $month');
  }

  final daysInMonth = DateTime(year, month + 1, 0).day;
  if (day < 1 || day > daysInMonth) {
    throw FormatException('Invalid day: $day for month: $month');
  }

  return DateTime.parse("$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}T16:00:00.000Z");
} 

String formatDateToLocalString(DateTime dateTime){
  String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  
  return formattedDate;
}

String formatTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}