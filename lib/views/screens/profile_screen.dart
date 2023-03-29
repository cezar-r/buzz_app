import 'package:buzz_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    double bannerHeight = MediaQuery.of(context).size.height * 0.2;
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  height: bannerHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          controller.user['bannerPhotoPath']
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: bannerHeight / 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: controller.user['profilePhotoPath'],
                                        height: 150,
                                        width: 150,
                                        placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.error,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "@${controller.user['username']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          controller.user['following'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Following',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.black54,
                                      width: 1,
                                      height: 15,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          controller.user['followers'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Followers',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.black54,
                                      width: 1,
                                      height: 15,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          controller.user['likes'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Likes',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                controller.user['bio'] != null
                                    ? Text(
                                  "@${controller.user['bio']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                )
                                    : Text("", style: TextStyle(fontSize: 1),),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: 140,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.uid == authController.user.uid) {
                                          authController.signOut();
                                        } else {
                                          controller.followUser();
                                        }
                                      },
                                      child: Text(
                                        widget.uid == authController.user.uid
                                            ? 'Sign Out'
                                            : controller.user['isFollowing']
                                            ? 'Unfollow'
                                            : 'Follow',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                // video list
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.user['thumbnails'].length,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    String thumbnail =
                                    controller.user['thumbnails'][index];
                                    return CachedNetworkImage(
                                      imageUrl: thumbnail,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
              ],
            ),
          );
        });
  }
}
