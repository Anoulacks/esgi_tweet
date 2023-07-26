import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/profile/profile_screen.dart';
import 'package:esgi_tweet/screens/profile/user_selected_profile_screen.dart';
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

  const TweetCard({Key? key, required this.tweet, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return Column(
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: () {
              _goToProfile(context, user);
            },
            child: CircleAvatar(
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
          ),
          title: Row(
            children: [
              Text(
                user.firstname,
                style: TextStyle(
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
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
              tweet.image != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: GestureDetector(
                                  onTap: () => _showUserPictureDialog(
                                      context, tweet.image!),
                                  child: Image.network(
                                    tweet.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text(''),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TweetButton(
                    icon: Icons.chat,
                    value:
                        '${tweet.comments != null ? tweet.comments?.length : '0'}',
                    callback: _addComment,
                  ),
                  TweetLikeButton(
                    likes: tweet.likes,
                    callback: _updateLike,
                  ),
                ],
              ),
            ],
          ),
          onTap: () => {TweetDetailScreen.navigateTo(context, tweet)},
        ),
        const Divider(),
      ],
    );
  }

  void _goToProfile(BuildContext context, UserApp userApp) {
    if (userApp.id == BlocProvider.of<UsersBloc>(context).state.user?.id) {
      ProfileScreen.navigateTo(context, true);
    } else {
      UserSelectedProfilePage.navigateTo(context, userApp);
    }
  }

  void _updateLike(context) {
    final userId =
        RepositoryProvider.of<UsersRepository>(context).getCurrentUserID();
    RepositoryProvider.of<TweetsRepository>(context)
        .updateLikeTweet(tweet.id, userId);
  }

  void _addComment(context) {
    TweetAddScreen.navigateTo(context, tweet.id);
  }

  void _showUserPictureDialog(BuildContext context, String imageURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.network(
            imageURL ?? '',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
