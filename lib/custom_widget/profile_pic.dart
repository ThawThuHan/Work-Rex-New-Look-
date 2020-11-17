import 'package:flutter/material.dart';

class CustomCircleProfilePic extends StatelessWidget {
  const CustomCircleProfilePic({
    Key key,
    @required this.imgUrl,
    @required this.radius,
  }) : super(key: key);

  final String imgUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).accentColor),
          image: DecorationImage(
            image: NetworkImage(imgUrl),
          ),
        ),
      ),
    );
  }
}
