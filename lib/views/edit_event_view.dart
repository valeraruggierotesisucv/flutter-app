import 'package:eventify/utils/date_formatter.dart';
import 'package:eventify/view_models/edit_event_view_model.dart';
import 'package:eventify/views/add_date_view.dart';
import 'package:eventify/views/choose_category_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/audio_modal.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/custom_chip.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/display_input.dart';
import 'package:eventify/widgets/image_modal.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:eventify/widgets/modal.dart';
import 'package:eventify/views/add_event_view.dart' show StepsEnum;
import 'package:eventify/utils/result.dart';

import 'dart:io';

class EditEventView extends StatelessWidget {
  const EditEventView({
    super.key,
    required this.viewModel,
  });

  final EditViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return EditViewScreen(viewModel: viewModel);
  }
}

class EditViewScreen extends StatefulWidget {
  const EditViewScreen({super.key, required this.viewModel});
  final EditViewModel viewModel;

  @override
  State<EditViewScreen> createState() => _EditViewScreenState();
}

class _EditViewScreenState extends State<EditViewScreen> {
  late EditViewModel _viewModel;
  StepsEnum currentStep = StepsEnum.defaultStep;
  String? _category;
  String? _musicName;
  bool _isUpdatingEvent = false;

  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.getEventDetails.addListener(_onEventDetailsLoad);
    _viewModel.getEventDetails.execute(widget.viewModel.eventId);
  }

  @override
  void dispose() {
    _viewModel.getEventDetails.removeListener(_onEventDetailsLoad);
    super.dispose();
  }

  void _onEventDetailsLoad() {
    if (mounted) {
      setState(() {
        final event = _viewModel.event;
        if (event != null) {
          _category = event.category;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.getEventDetails.running) {
            return const Center(child: Loading());
          }

          return Column(
            children: [
              Expanded(
                child: _buildStepWidget(),
              ),
            ],
          );
        },
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
              _viewModel.event!.date = newDate!.toUtc().toIso8601String();
            });
          },
          onStartsAtChanged: (newDate) {
            setState(() {
              _viewModel.event!.startsAt = newDate!.toUtc().toIso8601String();
              DateTime startsAt = DateTime.parse(_viewModel.event!.startsAt);
              print("startsAt $startsAt");
            });
          },
          onEndsAtChanged: (newDate) {
            setState(() {
              _viewModel.event!.endsAt = newDate!.toUtc().toIso8601String();
            });
          },
        );
      case StepsEnum.categoryStep:
        return ChooseCategoriesView(
          onCategoryChanged: (newCategoryId, newCategory) {
            setState(() {
              _category = newCategory;
              _viewModel.event!.categoryId = newCategoryId.toString();
            });
          },
          onStepChanged: (newStep) {
            setState(() {
              currentStep = StepsEnum.defaultStep;
            });
          }
        );
      default:
        return _defaultWidget();
    }
  }

  Widget _defaultWidget() {
    return Scaffold(
      appBar: AppHeader(
        title: "Editar Evento",
        goBack: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _imagePickerWidget(),
                  _addTitle(),
                  _addDescription(),
                  _addDate(),
                  _addCategory(),
                  _addMusic(),
                  _addLocation(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16, right: 16, bottom: 32, top: 16,
            ),
            child: _addPublishButton(),
          ),
        ],
      ),
    );
  }

  Widget _imagePickerWidget() {
    return GestureDetector(
      onTap: () {
        showPhotoModal(
          context,
          onPhotoSelected: (photo) {
            setState(() {
              _viewModel.event?.eventImage = photo.path;
            });
          },
          onClose: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
      },
      child: _viewModel.event?.eventImage != null
          ? Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
              child: _viewModel.event!.eventImage.startsWith('http')
                  ? Image.network(_viewModel.event!.eventImage)
                  : Image.file(File(_viewModel.event!.eventImage)),
            )
          : Container(
              width: double.infinity,
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
              child: Icon(Icons.add, size: 48, color: Colors.black),
            ),
    );
  }

  Widget _addTitle() {
    return CustomInput(
      label: "Titulo",
      placeholder: "Agregar titulo",
      value: _viewModel.event?.title,
      multiline: false,
      variant: InputVariant.defaultInput,
      onChangeValue: (newValue) {
        setState(() {
          _viewModel.event?.title = newValue;
        });
      },
    );
  }

  Widget _addDescription() {
    return CustomInput(
      label: "Descripción",
      placeholder: "Agrega una descripción",
      value: _viewModel.event?.description,
      multiline: false,
      variant: InputVariant.defaultInput,
      onChangeValue: (newValue) {
        setState(() {
          _viewModel.event?.description = newValue;
        });
      },
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
              _viewModel.event!.date = '';
              _viewModel.event!.startsAt = '';
              _viewModel.event!.endsAt = '';
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
              _viewModel.event!.categoryId = '';
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
              _musicName = null;
              _viewModel.event?.musicUrl = '';
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
              _viewModel.event!.latitude = '';
              _viewModel.event!.longitude = '';
            });
          },
        ),
      ],
    );
  }

  Widget _addDate() {
    final event = _viewModel.event;
    if (event == null) return Container();
    
    return (event.date != "" && event.startsAt != "" && event.endsAt != "")
        ? DisplayInput(
            label: "CUANDO",
            data: _datePills(formatDateToLocalString(DateTime.parse(event.date)),
                formatTime(DateTime.parse(event.startsAt)), formatTime(DateTime.parse(event.endsAt))),
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

  Widget _addCategory() {
    return (_category != null)
        ? DisplayInput(label: "CATEGORIA", data: _categoryPill(_category!))
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

  Widget _addMusic() {
    final event = _viewModel.event;
    if (event == null) return Container();

    final hasMusic = event.musicUrl.isNotEmpty;
    final displayName = _musicName ??
        (event.musicUrl.startsWith('http') 
            ? event.musicUrl.length > 20 
                ? '${event.musicUrl.substring(0, 20)}...' 
                : event.musicUrl 
            : "");
    
    return hasMusic
        ? DisplayInput(
            label: "MUSICA", 
            data: _musicPill(displayName))
        : CustomInput(
            label: "MUSICA",
            placeholder: "Agrega música",
            variant: InputVariant.arrow,
            onPress: () {
              showAudioModal(
                context, 
                onClose: () {
                  Navigator.of(context, rootNavigator: true).pop();
                }, 
                onRecordingComplete: (recordedPath) {
                  setState(() {
                    _viewModel.event?.musicUrl = recordedPath ?? '';
                  });
                }, 
                onPickMusicFile: (music, musicUri) {
                  setState(() {
                    _musicName = music;
                    _viewModel.event?.musicUrl = musicUri;
                  });
                }
              );
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
        _viewModel.event!.latitude = locationData.latitude?.toString() ?? '';
        _viewModel.event!.longitude = locationData.longitude?.toString() ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener la ubicación')),
      );
    }
  }

  Widget _addLocation() {
    return (_viewModel.event!.latitude != "" && _viewModel.event!.longitude != "")
        ? DisplayInput(
            label: "UBICACIÓN",
            data: _locationPills(_viewModel.event!.latitude, _viewModel.event!.longitude),
          )
        : CustomInput(
            label: "UBICACIÓN",
            placeholder: "Agrega una ubicación",
            variant: InputVariant.arrow,
            onPress: _getLocation,
          );

  }

  void _handlePublish() async {
    if (!_viewModel.isValid) return;

    setState(() {
      _isUpdatingEvent = true;
    });

    try {
      final result = await _viewModel.updateEvent();
      if (result is Ok) {
        showSuccessModal(
          context,
          title: "¡Evento actualizado con éxito!",
          onClose: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      } else {
        throw (result as Error<void>).error;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el evento: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUpdatingEvent = false;
      });
    }
  }

  Widget _addPublishButton() {
    return CustomButton(
      label: _isUpdatingEvent ? "Actualizando..." : "Actualizar",
      onPress: _isUpdatingEvent ? null : _handlePublish,
      disabled: !_viewModel.isValid || _isUpdatingEvent,
    );
  }
}
