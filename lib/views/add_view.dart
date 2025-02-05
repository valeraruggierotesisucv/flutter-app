import 'package:eventify/widgets/app_header.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Nuevo Evento"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                debugPrint("click");
              },
              child: Container(
                width: double.infinity,
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                ),
                child: Icon(Icons.add, size: 48, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
