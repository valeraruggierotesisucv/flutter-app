import 'package:eventify/utils/string_formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String?) onRecordingComplete;
  final Function(String, String) onPickMusicFile;

  const AudioModal(
      {super.key,
      required this.onClose,
      required this.onRecordingComplete,
      required this.onPickMusicFile});

  @override
  State createState() => _AudioModalState();
}

class _AudioModalState extends State<AudioModal> {
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
          _isRecording = true;
        });
        debugPrint("Grabación iniciada");
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
      widget.onRecordingComplete(_recordedAudioPath);
      widget.onClose();
    } catch (e) {
      debugPrint("Error al detener la grabación: $e");
    }
  }

  Future<void> _pickMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.single.path != null && mounted) {
      String musicName = truncateString(result.files.single.name);
      String musicPath = result.files.single.path!;
      widget.onPickMusicFile(musicName, musicPath);
      widget.onClose(); 
    }
  }

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
            Column(
              children: [
                TextButton(
                  onPressed: _pickMusic,
                  child: Text(
                    "Elegir de archivos",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed:
                      _isRecording ? handleStopRecording : startRecording,
                  child: Text(
                    _isRecording ? "Detener grabación" : "Grabar audio",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: widget.onClose,
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
void showAudioModal(BuildContext context,
    {required VoidCallback onClose,
    required Function(String?) onRecordingComplete,
    required Function(String, String) onPickMusicFile}) {
  showDialog(
    context: context,
    builder: (context) => AudioModal(
      onPickMusicFile: onPickMusicFile,
      onClose: onClose,
      onRecordingComplete: onRecordingComplete,
    ),
  );
}
