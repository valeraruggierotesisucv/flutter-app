//import 'package:eventify/widgets/calendar.dart';
import 'package:eventify/views/add_event_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddDateView extends StatefulWidget {
  final Function(StepsEnum) onStepChanged;
  final Function(DateTime?) onDateChanged;
  final Function(DateTime?) onStartsAtChanged;
  final Function(DateTime?) onEndsAtChanged;

  const AddDateView(
      {super.key,
      required this.onStepChanged,
      required this.onDateChanged,
      required this.onStartsAtChanged,
      required this.onEndsAtChanged});

  @override
  State createState() => _AddDateViewState();
}

class _AddDateViewState extends State<AddDateView> {
  bool showError = false;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppHeader(
        title: t.addDateTitle,
        goBack: () {
          widget.onStepChanged(StepsEnum.defaultStep);
        }
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Calendar(
              initialStartTime: DateTime.now(),
              initialEndTime: DateTime.now(),
              maxDate: DateTime.now().add(Duration(days: 365)),
              date: selectedDate,
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                  widget.onDateChanged(selectedDate);
                });
              },
              onStartTimeChange: (time) {
                setState(() {
                  startTime = TimeOfDay.fromDateTime(time!);
                  widget.onStartsAtChanged(time);
                });
              },
              onEndTimeChange: (time) {
                setState(() {
                  endTime = TimeOfDay.fromDateTime(time!);
                  widget.onEndsAtChanged(time); 
                });
              },
            ),
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                t.addDateError,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomButton(
                label: t.addDateNext,
                onPress: () {
                  if (selectedDate != null && startTime != null && endTime != null) {
                    widget.onStepChanged(StepsEnum.defaultStep);
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
