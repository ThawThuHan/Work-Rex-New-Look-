import 'package:flutter/material.dart';
import '../../code_models/post_model.dart';
import '../../code_models/user_model.dart';
import '../../custom_widget/post_tile.dart';
import '../../custom_widget/profile_pic.dart';
import '../../custom_widget/profileplaceholder.dart';
import '../../screens/homeBNavigatorPages/create_post.dart';
import '../../services/post_database.dart';

class SubHome extends StatefulWidget {
  final WorkRexUser user;

  SubHome({this.user});

  @override
  _SubHomeState createState() => _SubHomeState();
}

class _SubHomeState extends State<SubHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          title: Text(
            'Work Rex',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 28.0,
              letterSpacing: 2.0,
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 25.0,
              icon: Icon(Icons.chat),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePost(
                              user: widget.user,
                            )),
                  );
                },
                leading: widget.user?.imgUrl == null
                    ? ProfilePlaceholder(
                        radius: 25.0,
                      )
                    : CustomCircleProfilePic(
                        imgUrl: widget.user.imgUrl,
                        radius: 25.0,
                      ),
                title: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'What is your Announcement?',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    child: Text('Public'),
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: Colors.black,
                  ),
                  Container(
                    width: 80,
                    child: Text('Department'),
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
              ),
              StreamBuilder<List<PostModel>>(
                stream: PostService.getPostsfromPublic(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          PostModel post = data[index];
                          return PostTile(
                              post: post, imgUrls: post.postImgUrls);
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
