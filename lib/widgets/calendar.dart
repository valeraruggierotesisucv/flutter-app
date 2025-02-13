import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calendar extends StatefulWidget {
  final DateTime? initialStartTime;
  final DateTime? initialEndTime;
  final DateTime? maxDate;
  final DateTime? date;
  final Function(DateTime?) onDateChange;
  final Function(DateTime?)? onStartTimeChange;
  final Function(DateTime?)? onEndTimeChange;

  const Calendar({
    super.key,
    this.initialStartTime,
    this.initialEndTime,
    this.maxDate,
    this.date,
    required this.onDateChange,
    this.onStartTimeChange,
    this.onEndTimeChange,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.date ?? DateTime.now();
    _selectedDay = widget.date;
    _startTime = widget.initialStartTime != null 
      ? TimeOfDay.fromDateTime(widget.initialStartTime!) 
      : null;
    _endTime = widget.initialEndTime != null 
      ? TimeOfDay.fromDateTime(widget.initialEndTime!) 
      : null;
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime 
        ? _startTime ?? TimeOfDay.now()
        : _endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          widget.onStartTimeChange?.call(
            DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 
              picked.hour, picked.minute)
          );
        } else {
          _endTime = picked;
          widget.onEndTimeChange?.call(
            DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 
              picked.hour, picked.minute)
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: widget.maxDate ?? DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDateChange(selectedDay);
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color(0xFFE0EFFF),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Color(0xFF2A90FF),
                fontWeight: FontWeight.bold,
              ),
            ),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomInput(
                  label: t.calendarStart,
                  placeholder: _startTime != null 
                    ? _formatTimeOfDay(_startTime)
                    : t.calendarSelectStartTime,
                  variant: InputVariant.arrow,
                  onPress: () => _selectTime(context, true),
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: t.calendarEnd,
                  placeholder: _endTime != null 
                    ? _formatTimeOfDay(_endTime)
                    : t.calendarSelectEndTime,
                  variant: InputVariant.arrow,
                  onPress: () => _selectTime(context, false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 