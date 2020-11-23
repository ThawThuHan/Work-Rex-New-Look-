import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  MyRaisedButton({
    @required this.label,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
