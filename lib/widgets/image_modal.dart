import 'package:flutter/material.dart';

class PhotoModal extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromGallery;
  final VoidCallback onClose;

  const PhotoModal({
    super.key,
    required this.onTakePhoto,
    required this.onChooseFromGallery,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
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
                  onPressed: onTakePhoto,
                  child: Text(
                    "Tomar foto",
                    style: TextStyle(color: Colors.blue, fontSize: 18), // Cambia el color y tamaño
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onChooseFromGallery,
                  child: Text(
                    "Elegir de la galería",
                    style: TextStyle(color: Colors.blue, fontSize: 18), // Cambia el color y tamaño
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onClose,
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.blue, fontSize: 18), // Cambia el color y tamaño
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
void showPhotoModal(BuildContext context, {required VoidCallback onTakePhoto, required VoidCallback onChooseFromGallery, required VoidCallback onClose}) {
  showDialog(
    context: context,
    builder: (context) => PhotoModal(
      onTakePhoto: onTakePhoto,
      onChooseFromGallery: onChooseFromGallery,
      onClose: onClose,
    ),
  );
}
