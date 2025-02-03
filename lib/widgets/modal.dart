import 'package:flutter/material.dart';

class SuccessModal extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const SuccessModal({
    super.key,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  onClose?.call();
                  Navigator.of(context).pop();
                },
              ),
            ),
            
            Image.asset(
              'assets/images/Success.png',  
              height: 240,
            ),
            const SizedBox(height: 16),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void showSuccessModal(BuildContext context, {required String title, VoidCallback? onClose}) {
  showDialog(
    context: context,
    builder: (context) => SuccessModal(
      title: title,
      onClose: onClose,
    ),
  );
}
