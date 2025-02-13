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
import 'package:eventify/widgets/modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  bool _isCreatingEvent = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppHeader(title: t.addEventTitle),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _imagePickerWidget(image: _image),
                  _addTitle(title: _title),
                  _addDescription(description: _description),
                  _addDate(date: _date, startsAt: _startsAt, endsAt: _endsAt),
                  _addCategory(category: _category),
                  _addMusic(music: _music),
                  _addLocation(latitude: _latitude, longitude: _longitude),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 32,
              top: 16,
            ),
            child: _addPublishButton(),
          ),
        ],
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
    final t = AppLocalizations.of(context)!;
    return CustomInput(
      label: t.addEventTitle,
      placeholder: t.addEventTitleHint,
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
    final t = AppLocalizations.of(context)!;
    return CustomInput(
      label: t.addEventDescription,
      placeholder: t.addEventDescriptionHint,
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
    final t = AppLocalizations.of(context)!;
    debugPrint(date.toString());
    debugPrint(startsAt.toString());
    debugPrint(endsAt.toString());
    return (date != null && startsAt != null && endsAt != null)
        ? DisplayInput(
            label: t.addEventDate,
            data: _datePills(formatDateToLocalString(date),
                formatTime(startsAt), formatTime(endsAt)),
          )
        : CustomInput(
            label: t.addEventDate,
            placeholder: t.addEventDateHint,
            variant: InputVariant.arrow,
            onPress: () => {
              setState(() {
                currentStep = StepsEnum.dateStep;
              })
            },
          );
  }

  Widget _addCategory({String? category}) {
    final t = AppLocalizations.of(context)!;
    return (category != null)
        ? DisplayInput(label: t.addEventCategory, data: _categoryPill(category))
        : CustomInput(
            label: t.addEventCategory,
            placeholder: t.addEventCategoryHint,
            variant: InputVariant.arrow,
            onPress: () => {
              setState(() {
                currentStep = StepsEnum.categoryStep;
              })
            },
          );
  }

  Widget _addMusic({String? music}) {
    final t = AppLocalizations.of(context)!;
    return (music != null)
        ? DisplayInput(label: t.addEventMusic, data: _musicPill(music))
        : CustomInput(
            label: t.addEventMusic,
            placeholder: t.addEventMusicHint,
            variant: InputVariant.arrow,
            onPress: () {
              showAudioModal(context, onClose: () {
                Navigator.of(context, rootNavigator: true).pop();
              }, onRecordingComplete: (recordedPath) {
                setState(() {
                  _music = t.addEventRecordedAudio;
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
        SnackBar(content: Text(AppLocalizations.of(context)!.addEventLocationError)),
      );
    }
  }

  Widget _addLocation({String? latitude, String? longitude}) {
    final t = AppLocalizations.of(context)!;
    return (latitude != null && longitude != null)
        ? DisplayInput(
            label: t.addEventLocation, 
            data: _locationPills(latitude, longitude))
        : CustomInput(
            label: t.addEventLocation,
            placeholder: t.addEventLocationHint,
            variant: InputVariant.arrow,
            onPress: _getLocation,
          );
  }

  bool _isFormValid() {
    return _image != null &&
        _title != null &&
        _title!.isNotEmpty &&
        _description != null &&
        _description!.isNotEmpty &&
        _date != null &&
        _startsAt != null &&
        _endsAt != null &&
        _category != null &&
        _categoryId != null &&
        _latitude != null &&
        _longitude != null;
  }

  void _clearForm() {
    setState(() {
      _image = null;
      _imageUri = null;
      _title = null;
      _description = null;
      _date = null;
      _startsAt = null;
      _endsAt = null;
      _category = null;
      _categoryId = null;
      _music = null;
      _musicUri = null;
      _latitude = null;
      _longitude = null;
    });
  }

  void _handlePublish() async {
    if (!_isFormValid()) return;

    setState(() {
      _isCreatingEvent = true;
    });

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

    try {
      await _viewModel.createEvent();
      _clearForm();
      showSuccessModal(
        context, 
        title: AppLocalizations.of(context)!.addEventSuccessTitle,
        onClose: () {
          
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.addEventErrorMessage(e.toString())),
        ),
      );
    } finally {
      setState(() {
        _isCreatingEvent = false;
      });
    }
  }

  Widget _addPublishButton() {
    final t = AppLocalizations.of(context)!;
    return CustomButton(
      label: _isCreatingEvent ? t.addEventPublishingButton : t.addEventPublishButton,
      onPress: _isCreatingEvent ? null : _handlePublish,
      disabled: !_isFormValid() || _isCreatingEvent,
    );
  }
}
