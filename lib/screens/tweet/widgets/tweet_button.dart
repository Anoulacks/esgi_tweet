import 'package:flutter/material.dart';

class TweetButton extends StatelessWidget {
  final IconData icon;
  final String value;
  final Function callback;

  const TweetButton({Key? key, required this.icon, required this.value, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              print("button pressed");
              callback(context);
            },
            icon: Icon(icon),
            iconSize: 18,
        ),
        Text(
          value,
          style: const TextStyle(
          color: Colors.black38,
          fontSize: 12.0,
        ),)
      ],
    );
  }
}
