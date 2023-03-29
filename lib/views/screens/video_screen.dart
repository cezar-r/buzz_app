import 'package:buzz_app/views/screens/profile_screen.dart';
import 'package:buzz_app/views/widgets/verified_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/video_controller.dart';
import '../../models/video.dart';
import '../widgets/expandable_caption.dart';
import '../widgets/video_player.dart';
import 'comment_screen.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  Widget _descContainer(Video data, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(left: 20, top: height/12,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  data.username,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 5,),
                data.isVerified ? VerifiedBadge() : SizedBox(height: 0),
              ],
            ),
            SizedBox(height: 5,),
            Container(
              width: width * 0.6, // Set the caption width to 60% of the screen
              child: data.caption.length > 100
                  ? ExpandableCaption(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                caption: data.caption,
              )
                  : Text(
                data.caption,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _engagementContainer(Video data, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 10, top: height/3.5, bottom: height/6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: data.uid),
                  )
                );
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: Image.network(data.profilePhoto).image,
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () =>
                      videoController.likeVideo(data.id),
                  child: Icon(
                    Icons.favorite,
                    size: 40,
                    color: data.likes.contains(
                        authController.user.uid)
                        ? Colors.redAccent[400]
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  data.likes.length.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Allows custom height
                    backgroundColor: Colors.transparent, // Set background to transparent
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: CommentScreen(id: data.id, height: MediaQuery.of(context).size.height * 0.7),
                      );
                    },
                  ),
                  child: const Icon(
                    Icons.comment,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  data.commentCount.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.reply,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  data.shareCount.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                  waveforms: data.waveforms,
                ),
                _engagementContainer(data, context),
                _descContainer(data, context),
              ],
            );
        });
      }),
    );
  }
}
