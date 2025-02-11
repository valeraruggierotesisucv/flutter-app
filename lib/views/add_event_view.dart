import 'package:eventify/utils/date_formatter.dart';
import 'package:eventify/view_models/add_event_view_model.dart';
import 'package:eventify/views/add_date_view.dart';
import 'package:eventify/views/choose_category_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/audio_modal.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/custom_chip.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/display_input.dart';
import 'package:eventify/widgets/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'dart:io';

enum StepsEnum {
  defaultStep,
  dateStep,
  categoryStep,
  locationStep,
}

class AddView extends StatelessWidget {
  const AddView({
    super.key,
    required this.viewModel,
  });

  final AddViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => AddViewScreen(viewModel: viewModel),
        );
      },
    );
  }
}

class AddViewScreen extends StatefulWidget {
  const AddViewScreen({super.key, required this.viewModel});
  final AddViewModel viewModel;

  @override
  State<AddViewScreen> createState() => _AddViewScreenState();
}

class _AddViewScreenState extends State<AddViewScreen> {
  late AddViewModel _viewModel;
  StepsEnum currentStep = StepsEnum.defaultStep;

  XFile? _image;
  String? _imageUri;
  String? _title;
  String? _description;
  DateTime? _date;
  DateTime? _startsAt;
  DateTime? _endsAt;
  String? _category;
  int? _categoryId;
  String? _music;
  String? _musicUri;
  String? _latitude;
  String? _longitude;

  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
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
            onCategoryChanged: (newCategoryId, newCategory) {
          setState(() {
            _category = newCategory;
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
            _addLocation(latitude: _latitude, longitude: _longitude),
            _addPublishButton(),
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
          onPhotoSelected: (photo) {
            setState(() {
              _image = photo;
              _imageUri = photo.path;
            });
          },
          onClose: () {
            Navigator.of(context, rootNavigator: true).pop();
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
        IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            setState(() {
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
        IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            setState(() {
              _category = null;
              _categoryId = null;
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
        ? DisplayInput(label: "MUSICA", data: _musicPill(music))
        : CustomInput(
            label: "MUSICA",
            placeholder: "Agrega música",
            variant: InputVariant.arrow,
            onPress: () {
              showAudioModal(context, onClose: () {
                Navigator.of(context, rootNavigator: true).pop();
              }, onRecordingComplete: (recordedPath) {
                setState(() {
                  _music = "Recorded audio";
                  _musicUri = recordedPath;
                });
              }, onPickMusicFile: (music, musicUri) {
                setState(() {
                  _music = music;
                  _musicUri = musicUri;
                });
              });
            },
          );
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get location
    try {
      locationData = await location.getLocation();
      setState(() {
        _latitude = locationData.latitude?.toString();
        _longitude = locationData.longitude?.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener la ubicación')),
      );
    }
  }

  Widget _addLocation({String? latitude, String? longitude}) {
    return (latitude != null && longitude != null)
        ? DisplayInput(
            label: "UBICACIÓN", 
            data: _locationPills(latitude, longitude))
        : CustomInput(
            label: "UBICACIÓN",
            placeholder: "Agrega ubicación",
            variant: InputVariant.arrow,
            onPress: _getLocation,
          );
  }

  void _handlePublish() async {
    _viewModel.imageUri = _imageUri;
    _viewModel.title = _title;
    _viewModel.description = _description;
    _viewModel.date = _date;
    _viewModel.startsAt = _startsAt;
    _viewModel.endsAt = _endsAt;
    _viewModel.categoryId = _categoryId;
    _viewModel.musicUri = _musicUri;
    _viewModel.latitude = _latitude;
    _viewModel.longitude = _longitude;

    debugPrint("[add_view] Creando evento...");
    debugPrint("music--> $_music, $_musicUri");
    debugPrint("image-->$_image, $_imageUri"); 
    await _viewModel.createEvent();
  }

  Widget _addPublishButton() {
    return CustomButton(
      label: "Publicar",
      onPress: _handlePublish,
    );
  }
}
