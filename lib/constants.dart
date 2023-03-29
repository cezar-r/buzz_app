import 'package:buzz_app/views/screens/add_video/add_video_screen.dart';
import 'package:buzz_app/views/screens/profile_screen.dart';
import 'package:buzz_app/views/screens/video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';

// COLORS
const black = Colors.black;
// const green = Colors.greenAccent; // [400]
const green = Color.fromRGBO(36, 241, 145, 1);
const blue = Colors.tealAccent;
const white = Colors.white;
const gray = Colors.grey;

// USER PREFERENCES
Map<String, List<String>> genres = {
  "rap": ["trap", "gangsta rap", "latin", "underground", "old school", "90s", "00s", "10s", "drill", "emo", "soundcloud"],
  "dance": ["tech house", "dubstep", "main stage", "future house", "bass house", "riddim", "drum n' bass", "techno", "hardstyle"],
  "country": ["alternative", "bluegrass", "early country", "pop", "folk", "appalachian", "progressive", "western"],
  "latin": ["reggaeton", "alternativo", "tango", "contemporary", "jazz", "mariachi", "pop", "salsa", "bachata", "merengue", "rumba"],
  "metal": ["heavy", "thrash", "power", "death", "folk", "gothic", "glam", "progressive", "avantgarde"],
  "rock": ["classic", "glam","punk", "synth-pop", "progressive", "alternative", "indie", "rap-rock", "funk", "rock n' roll", "blues", "acid"],

};

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;

// PAGES
List pages = [
  VideoScreen(),
  Text('Search Screen'),
  AddVideoScreen(),
  Text('Messages Screen'),
  ProfileScreen(uid: authController.user.uid),
];
