import 'package:flutter/material.dart';
import 'package:workrex/code_models/post_model.dart';
import 'package:workrex/custom_widget/cached_networkImage.dart';
import 'package:workrex/custom_widget/profile_pic.dart';
import 'package:workrex/custom_widget/profileplaceholder.dart';
import 'package:workrex/custom_widget/timeago.dart';

class PostTile extends StatelessWidget {
  PostTile({
    @required this.post,
    @required this.imgUrls,
  });

  final PageController pageController = PageController(
    viewportFraction: 0.8,
  );
  final PostModel post;
  final List<dynamic> imgUrls;

  @override
  Widget build(BuildContext context) {
    List<Widget> viewPhotos = post.postImgUrls.map((e) {
      return Container(
        padding: EdgeInsets.all(8.0),
        // width: 100.0,
        child: CustomCachedNetworkImage(
          mediaUrl: e,
        ),
      );
    }).toList();
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: post.postOwnerImgUrl.isEmpty
                ? ProfilePlaceholder(radius: 22.0)
                : CustomCircleProfilePic(
                    imgUrl: post.postOwnerImgUrl,
                    radius: 22.0,
                  ),
            title: Text(post.postOwnerName),
            subtitle: Text(post.postOwerDept),
            trailing: Text(Timeago.displayTimeAgoFromTimestamp(
                post.onCreated.toDate().toString())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.postText,
                  maxLines: 5,
                  style: TextStyle(fontSize: 18.0),
                ),
                imgUrls.isEmpty
                    ? Container()
                    : Container(
                        height: 300.0,
                        child: PageView(
                          controller: pageController,
                          // scrollDirection: Axis.horizontal,
                          children: viewPhotos,
                        ),
                      ),
              ],
            ),
          ),
          imgUrls.isEmpty
              ? SizedBox(
                  height: 20.0,
                )
              : Container(),
          Divider(
            thickness: 2.0,
          ),
        ],
      ),
    );
  }
}
