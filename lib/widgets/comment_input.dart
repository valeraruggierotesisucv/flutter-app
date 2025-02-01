import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  final Function(String) onSubmit;
  const CommentInput({super.key, required this.onSubmit});
  @override
  State<CommentInput> createState() => _CommentInputState();

}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  bool canSend = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),

              onSubmitted: (value) {
                widget.onSubmit(value);
                _controller.clear();
              },
              onChanged: (value) {
                setState(() {
                  canSend = value.isNotEmpty;
                });
              },
            ),
          ),


          IconButton(
            onPressed: canSend 
              ? () {
                  widget.onSubmit(_controller.text);
                  _controller.clear();
                  setState(() {
                    canSend = false;  // Reset the state after sending
                  });
                }
              : null,  // Button is disabled when null
            icon: Icon(
              Icons.send_rounded, 
              color: canSend ? Colors.black : Colors.grey,
            ),
          )



        ],
      ),
    );
  }
}
