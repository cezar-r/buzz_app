import 'package:buzz_app/controllers/auth_controller.dart';
import 'package:buzz_app/views/screens/auth/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

/// TODO
/// preload videos
/// upload videos faster
/// pfp creation (ability to zoom in and change parts of it)
/// same for banner photo
/// fix soundbar: make waves more distinct in terms of sizing as well as gaps in color changing
/// fix login flow
/// pause video when clicking on profile
///
/// finish rest of app
/// add way for user to add links
/// figure out if i need to do anything with video_player Info.plist
///     from end of "Confirm Video Screen"
/// check if video is public/private when looking for videos
/// search page should consist of accounts and videos
/// add ability to message people
/// add ability to share videos (pop up to send to friends or copy link)
/// when user taps on video on profile, it should open up said video
/// add # of times video was viewed to video controller
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  runApp(const BuzzApp());
}


class BuzzApp extends StatelessWidget {
  const BuzzApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Buzz",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: black,
      ),
      home: SignupScreen(),
    );
  }
}