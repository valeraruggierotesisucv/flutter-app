import 'package:flutter/material.dart';
import 'comment_item.dart';
import 'comment_input.dart';

class User {
  final String username;
  final String imageUrl;
  User({required this.username, required this.imageUrl});
}


class Comment {
  final String username;
  final DateTime timeAgo;
  final String message;


  Comment({required this.username, required this.timeAgo, required this.message});
}


void showCommentsModal(BuildContext context, List<Comment> comments, User userInfo, Function(Comment) onSubmit) {
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
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (ctx, index) => CommentItem(
                    username: comments[index].username,
                    timeAgo: comments[index].timeAgo,
                    comment: comments[index].message,
                  ),
                ),
              ),

              CommentInput(
                onSubmit: (message) async {
                  try {
                    await onSubmit(Comment(
                      username: userInfo.username, 
                      timeAgo: DateTime.now(), 
                      message: message
                    ));
                    setState(() {
                      comments.add(Comment(
                        username: userInfo.username, 
                        timeAgo: DateTime.now(), 
                        message: message
                      ));

                  });
                  } catch (e) {
                    print("Error submitting comment: $e");
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
