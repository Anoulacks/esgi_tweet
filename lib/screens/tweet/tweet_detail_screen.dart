import 'package:esgi_tweet/blocs/tweets_bloc/tweets_bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/tweet/tweet_add_screen.dart';
import 'package:esgi_tweet/screens/tweet/widgets/tweet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetDetailScreen extends StatefulWidget {
  static const String routeName = '/TweetDetail';

  static void navigateTo(BuildContext context, Tweet tweet) {
    Navigator.of(context).pushNamed(routeName, arguments: tweet);
  }

  final Tweet tweet;

  const TweetDetailScreen({Key? key, required this.tweet}) : super(key: key);

  @override
  State<TweetDetailScreen> createState() => _TweetDetailScreenState();
}

class _TweetDetailScreenState extends State<TweetDetailScreen> {

  @override
  void initState() {
    super.initState();
    _fetchTweets();
  }

  void _fetchTweets() {
    print('test');
    context.read<TweetsBloc>().add(GetTweetsDetail(widget.tweet));
  }


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tweet Detail'),
          centerTitle: true,
        ),
        body: BlocBuilder<TweetsBloc, TweetsState>(
          builder: (context, state) {
            switch (state.status) {
              case TweetsStatus.initial:
                return const SizedBox();
              case TweetsStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case TweetsStatus.error:
                return Center(
                  child: Text(state.error),
                );
              case TweetsStatus.success:
                final tweets = state.tweetsDetail;

                if (tweets.isEmpty) {
                  return const Center(
                    child: Text('Aucun tweet'),
                  );
                }

                return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (context, index) {
                    final tweet = tweets[index];
                    return FutureBuilder<UserApp>(
                      future: RepositoryProvider.of<UsersRepository>(context)
                          .getUserById(tweet.userId),
                      builder: (BuildContext context,
                          AsyncSnapshot<UserApp> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text('Error: ${snapshot.error}');
                        }
                        UserApp userApp = snapshot.data!;
                        if (snapshot.hasData) {
                          return TweetCard(
                            tweet: tweet,
                            user: userApp,
                          );
                        }
                        return Text('Error: pas de données');
                      },
                    );
                  },
                );
            }
          },
        ),
      );
    });
  }
}
