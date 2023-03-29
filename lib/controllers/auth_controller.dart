import 'dart:io';

import 'package:buzz_app/constants.dart';
import 'package:buzz_app/controllers/profile_photo_controller.dart';
import 'package:buzz_app/controllers/user_prefs_controller.dart';
import 'package:buzz_app/models/user.dart' as model;
import 'package:buzz_app/views/screens/auth/login_screen.dart';
import 'package:buzz_app/views/screens/auth/signup_screen.dart';
import 'package:buzz_app/views/screens/auth/user_genre_prefs_screen.dart';
import 'package:buzz_app/views/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class AuthController extends GetxController {

  static AuthController instance = Get.find();
  late Rx<User?> _user;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    // Get.offAll(() => SignupScreen());
    print(user?.uid);
    if (user == null) {
      Get.offAll(() => LoginScreen());
    }
    else {
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<File> _readFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final bytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').writeAsBytes(bytes);
    return file;
  }

  Future<File> _pathToFile(String path) async {
    // might need to do try catch for returning asset image as file
    try {
      // reading path from assets
      return _readFromAssets(path);
    } catch(e) {
      // return File(path)
      return File(path);
    }
  }

  Future<String> _uploadImageToStorage(String path, String firebasePath) async {
    final File photo = await _pathToFile(path);

    final Reference ref = firebaseStorage.ref().child(firebasePath).child(firebaseAuth.currentUser!.uid);
    final TaskSnapshot snap= await ref.putFile(photo);
    final String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<UserCredential?> initialRegisterUser(String username, String email, String password) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password);
        return cred;
      } else {
        Get.snackbar('Error Creating Account', 'Enter all fields');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
      return null;
    }
  }

  void storeUser(
      TextEditingController usernameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      UserPreferencesController genrePreferencesController,
      ProfileSetupController photoController,
      TextEditingController bioController
      ) async {
    print(user.uid);
    String uid = firebaseAuth.currentUser!.uid;

    try {
      String downloadProfilePhotoURL = await _uploadImageToStorage(photoController.profilePhotoPath, 'profilePics');
      String downloadBannerPhotoURL = await _uploadImageToStorage(photoController.profileBannerPath, 'bannerPics');

      model.User user = model.User(
        username: usernameController.text,
        email: emailController.text,
        genrePreferences: genrePreferencesController.preferences,
        profilePhotoPath: downloadProfilePhotoURL,
        bannerPhotoPath: downloadBannerPhotoURL,
        bio: bioController.text,
        isVerified: false,
        uid: uid,
      );

      firestore.collection('users').doc(uid).set(user.toJson());
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}