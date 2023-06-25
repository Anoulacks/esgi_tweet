import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/screens/tweet/widgets/tweet_button.dart';
import 'package:esgi_tweet/utils/date_utils.dart';
import 'package:flutter/material.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final UserApp user;

  const TweetCard({Key? key, required this.tweet,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Text('Z')),
          title: Row(
            children: [
              Text(
                  user.firstname,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '@${user.pseudo} | ',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                ),
              ),
              Text(
                timestampToString(tweet.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  tweet.body,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              tweet.image != null ? Image.network(tweet.image!) : const Text(''),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TweetButton(icon: Icons.chat, value: '${tweet.likes != null ? tweet.likes?.length : '0'}'),
                  TweetButton(icon: Icons.favorite, value: '${tweet.comments != null ? tweet.comments?.length : '0'}'),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
