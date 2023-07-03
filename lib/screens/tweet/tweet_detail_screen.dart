import 'package:esgi_tweet/blocs/tweets_bloc/tweets_bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
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
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _fetchTweets();
    _getCurrentUserId();
  }

  void _fetchTweets() {
    context.read<TweetsBloc>().add(GetTweetsDetail(widget.tweet));
  }

  void _getCurrentUserId() async {
    String currentUser = await RepositoryProvider.of<UsersRepository>(context).getCurrentUserID();

    setState(() {
      currentUserId = currentUser;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tweet'),
          centerTitle: true,
          actions: [
            if (currentUserId == widget.tweet.userId)
              IconButton(onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
                  icon: Icon(Icons.delete))
          ],
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le tweet'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce tweet ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTweet();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTweet() {
    final tweetBloc = BlocProvider.of<TweetsBloc>(context);
    tweetBloc.add(DeleteTweet(widget.tweet));
    _showSnackBar(context, "Tweet supprimé");
    Navigator.pop(context);
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
