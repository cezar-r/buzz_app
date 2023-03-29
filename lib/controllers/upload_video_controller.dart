import 'dart:io';

import 'package:buzz_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../models/video.dart';

class UploadVideoController extends GetxController {

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.HighestQuality,
    );
    return compressedVideo!.file;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadVideoToStorage(String uid, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(uid);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(String uid, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(uid);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String videoPath,
              String caption,
              String songName,
              bool showWaveforms,
              bool publicUpload,
              List waveforms,
              bool isVerified,
              ) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoId = "Video$len";
      String videoUrl = await _uploadVideoToStorage(videoId, videoPath);
      String thumbnailUrl = await _uploadImageToStorage(videoId, videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: videoId,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhotoPath'],
        includeWaveforms: showWaveforms,
        publicUpload: publicUpload,
        waveforms: waveforms,
        isVerified: isVerified,
      );

      await firestore.collection('videos').doc(videoId).set(video.toJson());
      Get.back();
    } catch(e) {
      Get.snackbar('Error uploading video', e.toString());
    }
  }
}