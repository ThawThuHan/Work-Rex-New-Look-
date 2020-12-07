import 'package:flutter/material.dart';
import 'package:workrex/screens/homeBNavigatorPages/create_post.dart';
import '../code_models/post_model.dart';
import '../custom_widget/cached_networkImage.dart';
import '../custom_widget/profile_pic.dart';
import '../custom_widget/profileplaceholder.dart';
import '../custom_widget/timeago.dart';
import 'image_viewer.dart';

class PostTile extends StatelessWidget {
  PostTile({
    @required this.post,
    this.username,
  });

  final PostModel post;
  final String username;

  buildPostHeader(BuildContext context,
      {String profilePic, String name, String dept, String timeago}) {
    return Row(
      children: [
        profilePic == null
            ? ProfilePlaceholder(radius: 22.0)
            : CustomCircleProfilePic(
                imgUrl: post.postOwnerImgUrl,
                radius: 22.0,
              ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$dept .',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text('$timeago')
                ],
              ),
            ],
          ),
        ),
        post.postOwnerName == username
            ? IconButton(
                splashRadius: 20.0,
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePost(
                              post: post,
                            )),
                  );
                },
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("${post.postOwnerName}, $username");
    List<Widget> viewPhotos = post.postImgUrls.map((e) {
      return Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageViewer(imgUrl: e)));
            },
            child: Container(
              // padding: EdgeInsets.all(8.0),
              child: CustomCachedNetworkImage(
                mediaUrl: e,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${post.postImgUrls.indexOf(e) + 1}/${post.postImgUrls.length}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildPostHeader(
                  context,
                  profilePic: post.postOwnerImgUrl,
                  name: post.postOwnerName,
                  dept: post.postOwerDept,
                  timeago: post.onCreated != null
                      ? Timeago.displayTimeAgoFromTimestamp(
                          post.onCreated.toDate().toString())
                      : '',
                ),
                SizedBox(
                  height: 8.0,
                ),
                SelectableText(
                  post.postText,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                post.postImgUrls.isEmpty
                    ? SizedBox(
                        height: 5.0,
                      )
                    : Container(
                        height: 400,
                        child: PageView(
                          children: viewPhotos,
                        ),
                      ),
                Divider(
                  thickness: 2.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
