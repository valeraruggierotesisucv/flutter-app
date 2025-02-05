import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _title;
  String? _description; 

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
      appBar: AppHeader(title: "Nuevo Evento"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePickerWidget(image: _image),
            _addTitle(title: _title),
            _addDescription(description: _description)
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
}
