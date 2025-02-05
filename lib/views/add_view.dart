import 'package:eventify/views/add_date_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_chip.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/display_input.dart';
import 'package:eventify/widgets/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum StepsEnum {
  DEFAULT,
  DATE,
  CATEGORY,
  LOCATION,
}

class AddView extends StatelessWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const AddViewScreen(),
        );
      },
    );
  }
}

class AddViewScreen extends StatefulWidget {
  const AddViewScreen({super.key});

  @override
  State<AddViewScreen> createState() => _AddViewScreenState();
}

class _AddViewScreenState extends State<AddViewScreen> {
  StepsEnum currentStep = StepsEnum.DEFAULT;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _title;
  String? _description;
  String? _date;
  String? _startsAt;
  String? _endsAt;

  Future<void> _takePhoto() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, maxHeight: 250);
    if (photo != null && mounted) {
      setState(() {
        _image = photo;
      });
      debugPrint('Foto tomada: ${photo.path}');
      Navigator.of(context).pop();
    }
  }

  Future<void> _chooseFromGallery() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.gallery, maxHeight: 250);
    if (photo != null && mounted) {
      setState(() {
        _image = photo;
      });
      debugPrint('Foto seleccionada: ${photo.path}');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child:
                _buildStepWidget(), // Renderiza el widget según el paso actual
          ),
        ],
      ),
    );
  }

  Widget _buildStepWidget() {
    switch (currentStep) {
      case StepsEnum.DEFAULT:
        return _defaultWidget();

      case StepsEnum.DATE:
        return AddDateView(); 
      default:
        return _defaultWidget();
    }
  }

  Widget _defaultWidget() {
    return Scaffold(
      appBar: AppHeader(title: "Nuevo Evento"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePickerWidget(image: _image),
            _addTitle(title: _title),
            _addDescription(description: _description),
            _addDate(date: _date, startsAt: _startsAt, endsAt: _endsAt),
          ],
        ),
      ),
    );
  }

  Widget _imagePickerWidget({XFile? image}) {
    return GestureDetector(
      onTap: () {
        showPhotoModal(
          context,
          onTakePhoto: _takePhoto,
          onChooseFromGallery: _chooseFromGallery,
          onClose: () {
            Navigator.of(context).pop(); // Cierra el modal
          },
        );
      },
      child: image != null
          ? Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
              child: Image.file(File(image.path)),
            )
          : Container(
              width: double.infinity,
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Icon(Icons.add, size: 48, color: Colors.black),
            ),
    );
  }

  Widget _addTitle({String? title}) {
    return CustomInput(
      label: "Titulo",
      placeholder: "Agregar titulo",
      multiline: false,
      variant: InputVariant.defaultInput,
      onChangeValue: (newValue) {
        setState(() {
          title = newValue;
        });
      },
      required: title != null ? true : false,
    );
  }

  Widget _addDescription({String? description}) {
    return CustomInput(
      label: "Descripción",
      placeholder: "Agrega una descripción de tu evento",
      variant: InputVariant.defaultInput,
      multiline: false,
      onChangeValue: (newValue) {
        setState(() {
          description = newValue;
        });
      },
      required: description != null ? true : false,
    );
  }

  Widget _addDate({String? date, String? startsAt, String? endsAt}) {
    return GestureDetector(
      onTap: () => debugPrint("TAP"),
      child: (date != null && startsAt != null && endsAt != null)
          ? DisplayInput(
              label: "CUANDO",
              data: CustomChip(label: "label"),
            )
          : CustomInput(
              label: "CUANDO",
              placeholder: "Agrega fecha y hora",
              variant: InputVariant.arrow,
              onPress: () => {
                setState(() {
                  currentStep = StepsEnum.DATE;
                })
              },
            ),
    );
  }
}
