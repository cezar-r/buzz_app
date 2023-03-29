import 'dart:io';
import 'package:buzz_app/controllers/profile_photo_controller.dart';
import 'package:buzz_app/controllers/user_prefs_controller.dart';
import 'package:buzz_app/views/screens/auth/user_genre_prefs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ProfileSetupScreen extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final UserPreferencesController genreController;

  const ProfileSetupScreen({
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.genreController,
    Key? key}) : super(key: key);

  @override
  _ProfileSetupScreen createState() => _ProfileSetupScreen();
}

class _ProfileSetupScreen extends State<ProfileSetupScreen> {
  final ProfileSetupController _photoController = ProfileSetupController();
  final TextEditingController _bioController = TextEditingController();

  bool _selectedBannerPhoto = false;
  bool _selectedProfilePhoto = false;

  final picker = ImagePicker();

  void getProfilePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photoController.profilePhotoPath = pickedFile.path;
        _selectedProfilePhoto = true;
      }
    });
  }

  void getBannerPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photoController.profileBannerPath = pickedFile.path;
        _selectedBannerPhoto = true;
      }
    });
  }

  Widget _displayBannerPhoto() {
    if (_selectedBannerPhoto == false) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          _photoController.profileBannerPath,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Image.file(
          File(_photoController.profileBannerPath),
          fit: BoxFit.fill,
        ),
      );
    }
  }

  ImageProvider<Object> _displayProfilePhoto() {
    if (_selectedProfilePhoto == false) {
      return Image.asset(
        _photoController.profilePhotoPath,
        fit: BoxFit.fill,
      ).image;
    } else {
      return Image.file(
        File(_photoController.profilePhotoPath),
        fit: BoxFit.fill,
      ).image;
    }
  }


  @override
  Widget build(BuildContext context) {
    // Add your widget tree here
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    _displayBannerPhoto(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: black,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: green,
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                            onPressed: () {
                              getBannerPhoto();
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: white,
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 8,
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 50, bottom: MediaQuery.of(context).size.height/3, left: 10, right: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: gray,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                controller: _bioController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  hintText: 'Write a bio...',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    UserCredential? cred = await authController.initialRegisterUser(
                                      widget.usernameController.text,
                                      widget.emailController.text,
                                      widget.passwordController.text,
                                    );

                                    if (cred != null) {
                                      authController.storeUser(
                                          widget.usernameController,
                                          widget.emailController,
                                          widget.passwordController,
                                          widget.genreController,
                                          _photoController,
                                          _bioController);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: green,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: green,
                                          width: 3,
                                        )
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "Complete",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                onPressed: () {
                  // push context
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: white,
                ),
              )
          ),
          Center(
            heightFactor: 2.25,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: _displayProfilePhoto(),
                  backgroundColor: white,
                ),
                Positioned(
                  bottom: 0,
                  left: 95,
                  child: Container(
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: green,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                        onPressed: () {
                          getProfilePhoto();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: white,
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/**
 * TODO:
 * setup firebase
 */