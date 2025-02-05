import 'package:eventify/widgets/app_header.dart';
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

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null && mounted) {
      // Aquí puedes manejar la imagen capturada
      setState(() {
        _image = photo;
      });
      debugPrint('Foto tomada: ${photo.path}');
      Navigator.of(context).pop();
    }
  }

  Future<void> _chooseFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null && mounted) {
      // Aquí puedes manejar la imagen seleccionada
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
            GestureDetector(
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
              child: 
              _image != null 
              ? Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  child: Image.file(File(_image!.path)),
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
            )
          ],
        ),
      ),
    );
  }
}
