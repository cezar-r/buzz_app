import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import 'video_studio/video_studio.dart';
import 'confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              onTap: () => pickVideo(ImageSource.gallery, context),
              title: const Text(
                  "Upload",
                style: TextStyle(
                  color: green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: green,
              ),
            ),
            ListTile(
              onTap: () => pickVideo(ImageSource.camera, context),
              title: const Text(
                "Record",
                style: TextStyle(
                  color: green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: green,
              ),
            ),
            ListTile(
              onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoStudio()));},
              title: const Text(
                "Studio",
                style: TextStyle(
                  color: green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: green,
              ),
            )
          ],
        )
      ),

    );
  }
}
