//import 'package:eventify/widgets/calendar.dart';
import 'package:eventify/views/add_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/calendar.dart';

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
    return Scaffold(
      appBar: AppHeader(
          title: "Cuando",
          goBack: () {
            widget.onStepChanged(StepsEnum.defaultStep);
          }),
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
          Align(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomButton(
                label:
                    "Siguiente", // Cambia esto por la traducción correspondiente
                onPress: () {
                  widget.onStepChanged(
                      StepsEnum.defaultStep); // Llama al callback
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
