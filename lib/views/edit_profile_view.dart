import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eventify/view_models/edit_profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileView extends StatefulWidget {
  final EditProfileViewModel viewModel;
  final VoidCallback? onProfileUpdated;
  
  const EditProfileView({
    super.key, 
    required this.viewModel,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  XFile? selectedImage;
  bool hasChanges = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (userId != null) {
      widget.viewModel.initLoad.execute(userId);
    }
    widget.viewModel.initLoad.addListener(_onLoad);
    nameController.addListener(_onFieldChanged);
    bioController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    widget.viewModel.initLoad.removeListener(_onLoad);
    nameController.removeListener(_onFieldChanged);
    bioController.removeListener(_onFieldChanged);
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _onLoad() {
    if (mounted && !_initialized && widget.viewModel.user != null) {
      setState(() {
        nameController.text = widget.viewModel.user!.fullname;
        bioController.text = widget.viewModel.user!.biography ?? '';
        _initialized = true;
      });
    }
  }

  void _onFieldChanged() {
    if (!_initialized) return;
    
    final originalName = widget.viewModel.user?.fullname ?? '';
    final originalBio = widget.viewModel.user?.biography ?? '';
    
    setState(() {
      hasChanges = nameController.text != originalName || 
                   bioController.text != originalBio ||
                   selectedImage != null;
    });
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        showPhotoModal(
          context,
          onPhotoSelected: (photo) {
            setState(() {
              selectedImage = photo;
              hasChanges = true;
            });
          },
          onClose: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: selectedImage != null 
              ? FileImage(File(selectedImage!.path))
              : (widget.viewModel.user?.profileImage != null 
                ? NetworkImage(widget.viewModel.user!.profileImage!)
                : null) as ImageProvider?,
            child: (selectedImage == null && widget.viewModel.user?.profileImage == null)
              ? const Icon(Icons.person, size: 40)
              : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF050F71),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        title: t.editProfileTitle,
        goBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  if(widget.viewModel.initLoad.running) {
                    return const Loading();
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: _buildProfileImage(),
                        ),
                        const SizedBox(height: 40),
                        InputField(
                          label: t.editProfileName,
                          hint: t.editProfileNameHint,
                          controller: nameController,
                          error: '',
                          variant: InputFieldVariant.grayBackground,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        InputField(
                          label: t.editProfileBio,
                          hint: t.editProfileBioHint,
                          controller: bioController,
                          error: '',
                          variant: InputFieldVariant.grayBackground,
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            CustomButton(
              label: t.editProfileSubmit,
              onPress: hasChanges ? () async {
                await widget.viewModel.updateProfile.execute(UserModel(
                  userId: widget.viewModel.user!.userId,
                  fullname: nameController.text,
                  biography: bioController.text,
                  profileImage: selectedImage?.path,
                  username: widget.viewModel.user!.username,
                  email: widget.viewModel.user!.email,
                  birthDate: widget.viewModel.user!.birthDate,
                  followersCounter: widget.viewModel.user!.followersCounter,
                  followingCounter: widget.viewModel.user!.followingCounter,
                ));
                widget.onProfileUpdated?.call();
                Navigator.pop(context);
              } : null,
            ),
          ],
        ),
      ),
    );
  }
}
