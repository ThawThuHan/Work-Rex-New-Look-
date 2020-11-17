import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:workrex/code_models/user_model.dart';
import 'package:workrex/custom_widget/profile_pic.dart';
import 'package:workrex/custom_widget/profileplaceholder.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final WorkRexUser user;
  final String currentUserid;

  ProfilePage({this.user, this.currentUserid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  WorkRexUser user;
  bool isUser = true;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    checkCurrentUser();
  }

  checkCurrentUser() {
    if (widget.currentUserid != widget.user.userid) {
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
                            onPressed: () {},
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
              showUserRating(),
              Divider(
                color: Theme.of(context).accentColor,
              ),
              FlatButton(
                onPressed: isUser ? null : () {},
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
                        '3.5',
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
                      buildRateReview('Communication', 3.5),
                      buildRateReview('performance', 3.5),
                      buildRateReview('personality', 3.5),
                      buildRateReview('TeamWork', 3.5),
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

  Column showUserRating() {
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
          rating: 3.5,
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
