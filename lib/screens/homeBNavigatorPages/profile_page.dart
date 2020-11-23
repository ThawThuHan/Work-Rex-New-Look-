import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:workrex/code_models/user_model.dart';
import 'package:workrex/custom_widget/profile_pic.dart';
import 'package:workrex/custom_widget/profileplaceholder.dart';
import 'package:workrex/main.dart';
import 'package:workrex/screens/homeBNavigatorPages/edit_profile.dart';
import 'package:workrex/screens/homeBNavigatorPages/ratingmodalbottomsheet.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final WorkRexUser user;
  final String currentUserid;
  final String currentUserName;

  ProfilePage({this.user, this.currentUserid, this.currentUserName});

  @override
  _ProfilePageState createState() => _ProfilePageState(user: user);
}

class _ProfilePageState extends State<ProfilePage> {
  WorkRexUser user;
  bool isUser = true;

  _ProfilePageState({this.user});

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  checkCurrentUser() {
    if (widget.currentUserid != user.userid) {
      isUser = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: isUser
                        ? IconButton(
                            splashColor: Colors.grey,
                            splashRadius: 20.0,
                            tooltip: 'Edit Profile',
                            color: Theme.of(context).accentColor,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    user: user,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: isUser
                        ? IconButton(
                            splashColor: Colors.grey,
                            splashRadius: 20.0,
                            tooltip: 'Logout',
                            color: Theme.of(context).accentColor,
                            icon: Icon(Icons.logout),
                            onPressed: () {
                              MyAuthService.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp(),
                                ),
                              );
                            },
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: user.imgUrl == null
                        ? ProfilePlaceholder(
                            radius: 70.0,
                          )
                        : CustomCircleProfilePic(
                            imgUrl: user.imgUrl,
                            radius: 70.0,
                          ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              showUserInfo(context),
              SizedBox(
                height: 10.0,
              ),
              showUserRating(user.overall.toDouble()),
              Divider(
                color: Theme.of(context).accentColor,
              ),
              FlatButton(
                onPressed: isUser
                    ? null
                    : () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => RateModalBottom(
                                  subjectId: widget.currentUserid,
                                  subjectName: widget.currentUserName,
                                  objectId: widget.user.userid,
                                  objectName: widget.user.name,
                                ));
                      },
                child: Text(
                  '+ Rate',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Divider(
                color: Theme.of(context).accentColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${user.overall.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 48.0,
                        ),
                      ),
                      Text('out of 5'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildRateReview(
                          'Performance', user.performance.toDouble()),
                      buildRateReview(
                          'Personality', user.personality.toDouble()),
                      buildRateReview('Knowledge', user.knowledge.toDouble()),
                      buildRateReview('TeamWork', user.teamwork.toDouble()),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildRateReview(String label, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 18.0, letterSpacing: 1.0),
        ),
        SizedBox(
          width: 20.0,
        ),
        SmoothStarRating(
          size: 20,
          rating: rating,
          isReadOnly: true,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          borderColor: Theme.of(context).accentColor,
          color: Theme.of(context).accentColor,
          starCount: 5,
          allowHalfRating: true,
        )
      ],
    );
  }

  Column showUserRating(double rate) {
    return Column(
      children: [
        Text(
          'Rate Overall Corporation',
          style: TextStyle(fontSize: 30.0),
        ),
        SizedBox(
          height: 10,
        ),
        SmoothStarRating(
          allowHalfRating: true,
          rating: rate,
          isReadOnly: true,
          size: 50,
          color: Theme.of(context).accentColor,
          borderColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }

  Container showUserInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCustomText(label: 'Email', isLabel: true),
              buildCustomText(label: 'ID', isLabel: true),
              buildCustomText(label: 'Department', isLabel: true),
              buildCustomText(label: 'Phone No.', isLabel: true),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCustomText(label: '-'),
                buildCustomText(label: '-'),
                buildCustomText(label: '-'),
                buildCustomText(label: '-'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                    message: user.email,
                    child: buildCustomText(label: user.email)),
                buildCustomText(label: user.staffId),
                buildCustomText(label: user.department),
                buildCustomText(label: user.phone),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCustomText({String label, bool isLabel = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18.0,
          // letterSpacing: 2.0,
          fontWeight: isLabel ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
