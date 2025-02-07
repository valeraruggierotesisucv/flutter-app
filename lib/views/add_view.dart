import 'package:eventify/utils/date_formatter.dart';
import 'package:eventify/utils/string_formatter.dart';
import 'package:eventify/views/add_date_view.dart';
import 'package:eventify/views/choose_category_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/audio_modal.dart';
import 'package:eventify/widgets/custom_chip.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/display_input.dart';
import 'package:eventify/widgets/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';

enum StepsEnum {
  defaultStep,
  dateStep,
  categoryStep,
  locationStep,
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
  StepsEnum currentStep = StepsEnum.defaultStep;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _title;
  String? _description;
  DateTime? _date;
  DateTime? _startsAt;
  DateTime? _endsAt;
  String? _category;
  String? _categoryId;
  String? _music;
  String? _musicUri;
  String? _latitude;
  String? _longitude;
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  void startRecording() async {
    try {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        await _audioRecorder.startRecorder(
          toFile: 'audio_recording.aac',
        );
        setState(() {
          _isRecording = true; // Actualiza el estado de grabación
        });
        debugPrint("Grabación iniciada");
        debugPrint("isRecording $_isRecording"); 
      } else {
        debugPrint("Permiso de micrófono no concedido");
      }
    } catch (e) {
      debugPrint("Error al iniciar la grabación: $e");
    }
  }

  void handleStopRecording() async {
    try {
      _recordedAudioPath = await _audioRecorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      debugPrint("Grabación detenida: $_recordedAudioPath");
    } catch (e) {
      debugPrint("Error al detener la grabación: $e");
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, maxHeight: 250);
    if (photo != null && mounted) {
      setState(() {
        _image = photo;
      });
      debugPrint('Foto tomada: ${photo.path}');
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
    }
  }

  Future<void> _pickMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      setState(() {
        _music = truncateString(result.files.single.name);
        _musicUri = result.files.single.path!;
        debugPrint("Archivo de musica-->$_musicUri");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _buildStepWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepWidget() {
    switch (currentStep) {
      case StepsEnum.defaultStep:
        return _defaultWidget();

      case StepsEnum.dateStep:
        return AddDateView(
          onStepChanged: (newStep) {
            setState(() {
              currentStep = newStep;
            });
          },
          onDateChanged: (newDate) {
            setState(() {
              _date = newDate;
            });
          },
          onStartsAtChanged: (newDate) {
            setState(() {
              _startsAt = newDate;
            });
          },
          onEndsAtChanged: (newDate) {
            setState(() {
              _endsAt = newDate;
            });
          },
        );
      case StepsEnum.categoryStep:
        return ChooseCategoriesView(
            onCategoryChanged: (newCategory, newCategoryId) {
          setState(() {
            _category = newCategory;
            _categoryId = newCategoryId;
            debugPrint("CategoryId $_categoryId");
          });
        }, onCategoryIdChanged: (newCategoryId) {
          setState(() {
            _categoryId = newCategoryId;
          });
        }, onStepChanged: (newStep) {
          setState(() {
            currentStep = StepsEnum.defaultStep;
          });
        });
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
            _addCategory(category: _category),
            _addMusic(music: _music),
            _addLocation(latitude: _latitude, longitude: _longitude)
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
          onClose: () {},
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
          _title = newValue;
        });
      },
      required: title != null ? false : true,
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
          _description = newValue;
        });
      },
      required: description != null ? false : true,
    );
  }

  Widget _datePills(String date, String startsAt, String endsAt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomChip(label: startsAt),
            SizedBox(width: 8),
            CustomChip(label: endsAt),
            SizedBox(width: 8),
            CustomChip(label: date),
          ],
        ),
        // Icono de borrar
        IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            setState(() {
              // Limpiar los valores de fecha
              _date = null;
              _startsAt = null;
              _endsAt = null;
            });
          },
        ),
      ],
    );
  }

  Widget _categoryPill(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [CustomChip(label: category), SizedBox(width: 8)],
        ),
        // Icono de borrar
        IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            setState(() {
              _category = null;
            });
          },
        ),
      ],
    );
  }

  Widget _musicPill(String music) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [CustomChip(label: music), SizedBox(width: 8)],
        ),
        // Icono de borrar
        IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            setState(() {
              _music = null;
              _musicUri = null;
            });
          },
        ),
      ],
    );
  }

  Widget _locationPills(String latitude, String longitude) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomChip(label: latitude),
            SizedBox(width: 8),
            CustomChip(label: longitude)
          ],
        ),
        // Icono de borrar
        IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            setState(() {
              _latitude = null;
              _longitude = null;
            });
          },
        ),
      ],
    );
  }

  Widget _addDate({DateTime? date, DateTime? startsAt, DateTime? endsAt}) {
    debugPrint(date.toString());
    debugPrint(startsAt.toString());
    debugPrint(endsAt.toString());
    return (date != null && startsAt != null && endsAt != null)
        ? DisplayInput(
            label: "CUANDO",
            data: _datePills(formatDateToLocalString(date),
                formatTime(startsAt), formatTime(endsAt)),
          )
        : CustomInput(
            label: "CUANDO",
            placeholder: "Agrega fecha y hora",
            variant: InputVariant.arrow,
            onPress: () => {
              setState(() {
                currentStep = StepsEnum.dateStep;
              })
            },
          );
  }

  Widget _addCategory({String? category}) {
    return (category != null)
        ? DisplayInput(label: "CATEGORIA", data: _categoryPill(category))
        : CustomInput(
            label: "CATEGORIA",
            placeholder: "Agrega una categoría",
            variant: InputVariant.arrow,
            onPress: () => {
              setState(() {
                currentStep = StepsEnum.categoryStep;
              })
            },
          );
  }

  Widget _addMusic({String? music}) {
    return (music != null)
        ? DisplayInput(label: "CATEGORIA", data: _musicPill(music))
        : CustomInput(
            label: "MUSICA",
            placeholder: "Agrega música",
            variant: InputVariant.arrow,
            onPress: () => {
              showAudioModal(context,
                  pickMusicFile: _pickMusic,
                  startRecording: startRecording,
                  handleStopRecording: handleStopRecording,
                  onClose: () {},
                  isRecording: _isRecording)
            },
          );
  }

  Widget _addLocation({String? latitude, String? longitude}) {
    return (latitude != null && longitude != null)
        ? DisplayInput(
            label: "CATEGORIA", data: _locationPills(latitude, longitude))
        : CustomInput(
            label: "UBICACIÓN",
            placeholder: "Agrega ubicación",
            variant: InputVariant.arrow,
            onPress: () => {},
          );
  }
}
