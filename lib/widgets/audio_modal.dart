import 'package:flutter/material.dart';

class AudioModal extends StatelessWidget {
  final VoidCallback pickMusicFile;
  final VoidCallback startRecording;
  final VoidCallback handleStopRecording;
  final VoidCallback onClose;
  final bool isRecording;

  const AudioModal({
    super.key,
    required this.pickMusicFile,
    required this.startRecording,
    required this.handleStopRecording,
    required this.onClose,
    required this.isRecording,
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
                  onPressed: pickMusicFile,
                  child: Text(
                    "Elegir de archivos",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: isRecording ? handleStopRecording : startRecording,
                  child: Text(
                    isRecording ? "Detener grabación" : "Grabar audio",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onClose,
                  child: Text(
                    "Cancelar",
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

// Función para mostrar el AudioModal
void showAudioModal(BuildContext context, {required VoidCallback pickMusicFile, required VoidCallback startRecording, required VoidCallback handleStopRecording, required VoidCallback onClose, required bool isRecording}) {
  showDialog(
    context: context,
    builder: (context) => AudioModal(
      pickMusicFile: pickMusicFile,
      startRecording: startRecording,
      handleStopRecording: handleStopRecording,
      onClose: onClose,
      isRecording: isRecording,
    ),
  );
}
