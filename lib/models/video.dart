import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnailUrl;
  String profilePhoto;
  bool includeWaveforms;
  bool publicUpload;
  List waveforms;
  bool isVerified;
  // Map<String, String> links

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.profilePhoto,
    required this.includeWaveforms,
    required this.publicUpload,
    required this.waveforms,
    required this.isVerified
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "id": id,
    "likes": likes,
    "commentCount": commentCount,
    "shareCount": shareCount,
    "songName": songName,
    "caption": caption,
    "videoUrl": videoUrl,
    "thumbnail": thumbnailUrl,
    "profilePhoto": profilePhoto,
    "includeWaveforms": includeWaveforms,
    "publicUpload": publicUpload,
    "waveforms": waveforms,
    "isVerified": isVerified,
  };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      commentCount: snapshot['commentCount'],
      shareCount: snapshot['shareCount'],
      songName: snapshot['songName'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      thumbnailUrl: snapshot['thumbnail'],
      profilePhoto: snapshot['profilePhoto'],
      includeWaveforms: snapshot['includeWaveforms'],
      publicUpload: snapshot['publicUpload'],
      waveforms: snapshot['waveforms'],
      isVerified: snapshot['isVerified'],
    );

  }

}