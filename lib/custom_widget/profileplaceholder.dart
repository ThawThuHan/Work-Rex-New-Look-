import 'package:flutter/material.dart';

class ProfilePlaceholder extends StatelessWidget {
  final double radius;

  ProfilePlaceholder({@required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: Image.asset('assets/images/profile placeholder.png'),
    );
  }
}
