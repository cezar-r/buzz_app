import 'package:flutter/material.dart';
import '../../../../constants.dart';

class VideoStudio extends StatelessWidget {
  const VideoStudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: green,
        ),
      ),
      body: const Center(
        child: Text(
          "Coming soon",
          style: TextStyle(
            color: green,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
