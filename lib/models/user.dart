

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String username;
  late String email;
  late String profilePhotoPath;
  late String bannerPhotoPath;
  late String bio;
  late List<String> genrePreferences;
  late String uid;
  late bool isVerified;

  User({
    required this.username,
    required this.email,
    required this.profilePhotoPath,
    required this.bannerPhotoPath,
    required this.bio,
    required this.genrePreferences,
    required this.uid,
    required this.isVerified
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "profilePhotoPath": profilePhotoPath,
    "bannerPhotoPath": bannerPhotoPath,
    "bio": bio,
    "genrePreferences": genrePreferences,
    "isVerified": isVerified,
    "uid": uid
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        username: snapshot['username'],
        email: snapshot['email'],
        profilePhotoPath: snapshot['profilePhotoPath'],
        bannerPhotoPath: snapshot['bannerPhotoPath'],
        bio: snapshot['bio'],
        genrePreferences: snapshot['genrePreferences'],
        isVerified: snapshot['isVerified'],
        uid: snapshot['uid']);
  }

}