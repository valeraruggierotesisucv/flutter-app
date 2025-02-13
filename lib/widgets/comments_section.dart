import 'package:eventify/models/comment_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:flutter/material.dart';
import 'comment_item.dart';
import 'comment_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class User {
  final String username;
  final String imageUrl;
  User({required this.username, required this.imageUrl});
}

void showCommentsModal(
  BuildContext context, 
  String eventId,
  Command1<void, String> fetchComments,
  ValueNotifier<List<CommentModel>> commentsListenable,
  Function(String) onSubmit,
) {
  final t = AppLocalizations.of(context)!;
  
  fetchComments.execute(eventId);

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
              Text(t.commentsTitle),
              Expanded(
                child: ListenableBuilder(
                  listenable: fetchComments,
                  builder: (context, child) {
                    if(fetchComments.running) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ValueListenableBuilder<List<CommentModel>>(
                      valueListenable: commentsListenable,
                      builder: (context, latestComments, _) {
                        return latestComments.isEmpty
                            ? Center(
                                child: Text(t.commentsEmpty),
                              )
                            : ListView.builder(
                                itemCount: latestComments.length,
                                itemBuilder: (ctx, index) => CommentItem(
                                  username: latestComments[index].username,
                                  timeAgo: latestComments[index].timestamp,
                                  comment: latestComments[index].comment,
                                  profileImage: latestComments[index].profileImage,
                                ),
                              );
                      },
                    );
                  },
                ),
              ),
              CommentInput(
                onSubmit: (message) async {
                  try {
                    await onSubmit(message);
                  } catch (e) {
                    debugPrint(t.commentsSubmitError);
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
