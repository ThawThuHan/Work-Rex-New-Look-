import 'package:cached_network_image/cached_network_image.dart';
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
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).accentColor),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(imgUrl),
          ),
        ),
      ),
    );
  }
}
