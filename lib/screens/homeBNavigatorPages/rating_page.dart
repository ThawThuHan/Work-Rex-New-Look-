import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:workrex/code_models/user_model.dart';
import 'package:workrex/custom_widget/profile_pic.dart';
import 'package:workrex/services/user_database.dart';

class RatingPage extends StatefulWidget {
  final String dept;

  RatingPage({this.dept});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  Stream<List<WorkRexUser>> streamWorkRexUsers;

  @override
  void initState() {
    streamWorkRexUsers = UserService.getUserbyDepartment(widget.dept);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('** Users Rank **'),
        elevation: 0.0,
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<List<WorkRexUser>>(
              stream: streamWorkRexUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      WorkRexUser user = snapshot.data[index];
                      return Container(
                        child: Card(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      CustomCircleProfilePic(
                                        imgUrl: user.imgUrl,
                                        radius: 24.0,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SmoothStarRating(
                                            size: 25,
                                            rating: user.overall,
                                            isReadOnly: true,
                                            filledIconData: Icons.star,
                                            halfFilledIconData: Icons.star_half,
                                            defaultIconData: Icons.star_border,
                                            borderColor:
                                                Theme.of(context).accentColor,
                                            color:
                                                Theme.of(context).accentColor,
                                            starCount: 5,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  user.overall.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    // separatorBuilder: (_, __) {
                    //   return Divider();
                    // },
                    itemCount: snapshot.data.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
