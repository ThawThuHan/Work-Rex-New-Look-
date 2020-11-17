import 'package:flutter/material.dart';
import '../code_models/post_model.dart';
import '../custom_widget/cached_networkImage.dart';
import '../custom_widget/profile_pic.dart';
import '../custom_widget/profileplaceholder.dart';
import '../custom_widget/timeago.dart';

class PostTile extends StatelessWidget {
  PostTile({
    @required this.post,
  });

  final PageController pageController = PageController(
    viewportFraction: 0.8,
  );
  final PostModel post;

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
            title: Text(
              post.postOwnerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                '${post.postOwerDept} ${Timeago.displayTimeAgoFromTimestamp(post.onCreated.toDate().toString())}'),
            trailing: IconButton(
              splashRadius: 20.0,
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
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
                post.postImgUrls.isEmpty
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
          post.postImgUrls.isEmpty
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
