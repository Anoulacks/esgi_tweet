import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../utils/shared_preferences.dart';

class ProfileCardItem extends StatelessWidget {
  final UserApp user;
  final VoidCallback onTap;

  const ProfileCardItem({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: user.photoURL != null
                      ? Image.network(user.photoURL!).image
                      : Image.asset('assets/images/pp_twitter.jpeg').image,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${user.firstname} ${user.lastname}",
                style: TextStyle(
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '@${user.pseudo}',
                style: TextStyle(
                  color: isDarkModeEnabled ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w200,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
