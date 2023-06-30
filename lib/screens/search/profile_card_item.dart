import 'package:flutter/material.dart';

import '../../models/user.dart';

class ProfileCardItem extends StatelessWidget {
  final UserApp user;
  const ProfileCardItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: user.photoURL != null ?
                Image.network(user.photoURL!).image:
                Image.asset('assets/images/pp_twitter.jpeg').image,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text(
              "${user.firstname} ${user.lastname}",
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              '@${user.pseudo}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w200,
                fontSize: 12,
              ),
            ),
          ],
        )
      ],
    );
  }
}