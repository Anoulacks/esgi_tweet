import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/screens/tweet/widgets/tweet_button.dart';
import 'package:flutter/material.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final UserApp user;
  final VoidCallback? onTap;

  const TweetCard({Key? key, required this.tweet,required this.user, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Text('A')),
      title: Text(
          user.firstname,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tweet.body,
            style: const TextStyle(
              color: Colors.black38,
              fontSize: 14.0,
            ),
          ),
          tweet.image != null ? Image.network(tweet.image!) : const Text(''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              TweetButton(icon: Icons.chat, value: '0'),
              TweetButton(icon: Icons.favorite, value: '200'),
            ],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
