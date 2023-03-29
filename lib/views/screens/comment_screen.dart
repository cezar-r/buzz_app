import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as tago;

import '../../constants.dart';
import '../../controllers/comment_controller.dart';

class CommentScreen extends StatelessWidget {
  final String id;
  final double height;
  CommentScreen({
    Key? key,
    required this.id,
    required this.height,
  }) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: size.height * 0.8, // Adjust this value based on your layout
              child: Obx(() {
                return Dismissible(
                  direction: DismissDirection.down,
                  onDismissed: (_) => Navigator.pop(context),
                  key: Key("CommentScreen"),
                  child: ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return Padding(
                          padding: index == 0
                              ? EdgeInsets.only(top: 15,)
                              : index == commentController.comments.length - 1
                              ? EdgeInsets.only(bottom: 60)
                              : EdgeInsets.zero,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: black,
                              backgroundImage: NetworkImage(comment.profilePhoto),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${comment.username}  ",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: comment.comment,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6,)
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  tago.format(
                                    comment.datePublished.toDate(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${comment.likes.length} likes',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: white,
                                  ),
                                )
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () =>
                                  commentController.likeComment(comment.id),
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                color: comment.likes
                                    .contains(authController.user.uid)
                                    ? green
                                    : white,
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  ListTile(
                    title: TextFormField(
                      controller: _commentController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Comment',
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: black,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: green,
                          ),
                        ),
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        commentController.postComment(_commentController.text);
                        _commentController.clear(); // Clear the text field
                        FocusScope.of(context).unfocus(); // Dismiss the keyboard
                      }, // Dismiss the keyboard
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 16,
                          color: green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}