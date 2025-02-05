//import 'package:eventify/widgets/calendar.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/calendar.dart';

class AddDateView extends StatefulWidget {
  const AddDateView({super.key});

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
      appBar: AppHeader(title: "Cuando"),
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
                });
              },
              onStartTimeChange: (time) {
                setState(() {
                  startTime = TimeOfDay.fromDateTime(time!);
                });
              },
              onEndTimeChange: (time) {
                setState(() {
                  endTime = TimeOfDay.fromDateTime(time!);
                });
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomButton(
                  label:
                      "Siguiente", // Cambia esto por la traducción correspondiente
                  onPress: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
