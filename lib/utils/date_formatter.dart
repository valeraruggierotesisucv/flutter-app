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
  final parts = date.split("/").reversed.toList();
  return DateTime.parse("${parts.join("-")}T16:00:00.000Z");
} 

String formatDateToLocalString(DateTime dateTime){
  String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  
  return formattedDate;
}

String formatTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}