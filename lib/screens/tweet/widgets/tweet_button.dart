import 'package:flutter/material.dart';

class TweetButton extends StatelessWidget {
  final IconData icon;
  final String value;

  const TweetButton({Key? key, required this.icon, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              print("button pressed");
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
