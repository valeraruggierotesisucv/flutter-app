import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoModal extends StatelessWidget {
  final Function(XFile photo) onPhotoSelected;
  final VoidCallback onClose;

  const PhotoModal({
    super.key,
    required this.onPhotoSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final ImagePicker picker = ImagePicker();
    
    Future<void> takePhoto() async {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera, maxHeight: 250);
      if (photo != null) {
        onPhotoSelected(photo);
        onClose();
      }
    }

    Future<void> chooseFromGallery() async {
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery, maxHeight: 250);
      if (photo != null) {
        onPhotoSelected(photo);
        onClose();
      }
    }
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Contenedor de botones del modal
            Column(
              children: [
                TextButton(
                  onPressed: takePhoto,
                  child: Text(
                    t.imageModalTakePhoto,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: chooseFromGallery,
                  child: Text(
                    t.imageModalChooseGallery,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onClose,
                  child: Text(
                    t.imageModalCancel,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Función para mostrar el PhotoModal
void showPhotoModal(BuildContext context, {required Function(XFile photo) onPhotoSelected, required VoidCallback onClose}) {
  showDialog(
    context: context,
    builder: (context) => PhotoModal(
      onPhotoSelected: onPhotoSelected,
      onClose: onClose,
    ),
  );
}
