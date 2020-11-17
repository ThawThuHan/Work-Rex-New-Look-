import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Icon(Icons.star),
          ),
        ),
      ),
    );
  }
}
