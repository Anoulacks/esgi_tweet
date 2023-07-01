import 'package:flutter/material.dart';

import '../../../utils/shared_preferences.dart';

class TweetButton extends StatelessWidget {
  final IconData icon;
  final String value;
  final Function callback;

  const TweetButton({Key? key, required this.icon, required this.value, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

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
          style: TextStyle(
            color: isDarkModeEnabled ? Colors.white : Colors.black,
            fontSize: 12.0,
        ),)
      ],
    );
  }
}
