import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/tweet/tweet_add_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_detail_screen.dart';
import 'package:esgi_tweet/screens/tweet/widgets/tweet_button.dart';
import 'package:esgi_tweet/screens/tweet/widgets/tweet_like_button.dart';
import 'package:esgi_tweet/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/shared_preferences.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final UserApp user;

  const TweetCard({Key? key, required this.tweet,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: user.photoURL != null
                ? Image.network(
              user!.photoURL!,
              fit: BoxFit.cover,
            ).image
                : Image.asset(
              'assets/images/pp_twitter.jpeg',
              fit: BoxFit.cover,
            ).image,
          ),
          title: Row(
            children: [
              Text(
                  user.firstname,
                  style: TextStyle(
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                  style: TextStyle(
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              tweet.image != null ? Image.network(tweet.image!) : const Text(''),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TweetButton(icon: Icons.chat, value: '${tweet.comments != null ? tweet.comments?.length : '0'}', callback: _addComment,),
                  TweetLikeButton(likes: tweet.likes, callback: _updateLike,),
                ],
              ),
            ],
          ),
          onTap: () => {
            TweetDetailScreen.navigateTo(context, tweet)
          },
        ),
        const Divider(),
      ],
    );
  }

  void _updateLike(context) {
    final userId = RepositoryProvider.of<UsersRepository>(context).getCurrentUserID();
    RepositoryProvider.of<TweetsRepository>(context).updateLikeTweet(tweet.id, userId);
  }

  void _addComment(context) {
    TweetAddScreen.navigateTo(context, tweet.id);
  }
}
