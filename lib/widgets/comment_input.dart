import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentInput extends StatelessWidget {
  final Function(String) onSubmit;
  final _controller = TextEditingController();

  CommentInput({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: t.commentsInputHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                onSubmit(_controller.text);
                _controller.clear();
              }
            },
            tooltip: t.commentsInputSend,
          ),
        ],
      ),
    );
  }
}
