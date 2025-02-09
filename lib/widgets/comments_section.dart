import 'package:eventify/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'comment_item.dart';
import 'comment_input.dart';

class User {
  final String username;
  final String imageUrl;
  User({required this.username, required this.imageUrl});
}


void showCommentsModal(
  BuildContext context, 
  List<CommentModel> comments, 
  User userInfo, 
  Function(CommentModel) onSubmit,
  {bool isLoading = false}
) {
  showModalBottomSheet(
    context: context,

    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0)
      ),
    ),
    constraints: BoxConstraints.tight(Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height * .8
    )),
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[500],
                ),
              ),
              const Text("Comments"),
              Expanded(
                child: isLoading 
                  ? const Center(child: CircularProgressIndicator())
                    : comments.isEmpty
                      ? const Center(
                          child: Text('No comments yet'),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (ctx, index) => CommentItem(
                            username: comments[index].username,
                            timeAgo: comments[index].timestamp,
                            comment: comments[index].comment,
                            profileImage: comments[index].profileImage,
                          ),
                        ),
              ),
              CommentInput(
                onSubmit: (message) async {
                  try {
                    final newComment = CommentModel(
                      username: userInfo.username,
                      timestamp: DateTime.now(),
                      comment: message,
                      profileImage: userInfo.imageUrl
                    );
                    await onSubmit(newComment);
                    setState(() {
                      comments.add(newComment);
                    });
                  } catch (e) {
                    debugPrint("Error submitting comment: $e");
                  }
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}
